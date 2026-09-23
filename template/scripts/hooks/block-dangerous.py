#!/usr/bin/env python3
"""Check one Bash command before Claude Code runs it (PreToolUse hook, JSON on stdin).

Exit 2 blocks the command and prints the reason for the agent. Exit 0 lets it run.
Any other exit (a crash) is turned into a block by block-dangerous.sh.

How it works: it reads the command roughly the way bash does (quotes, line
continuations, subshells, if/for blocks, pipes, $(...), backticks, heredocs), then
applies a short list of rules for one-way doors to each simple command.
It is a pattern check, not a sandbox. It does not follow variables (x=rm; $x -rf ~),
aliases, scripts written by an earlier command, or commands run by other tools
(docker exec, xargs, find -exec, git submodule foreach). See the README's Limitations.
"""
import json
import os
import re
import sys
from urllib.parse import urlparse

SHELLS = {"sh", "bash", "zsh", "ksh", "dash", "fish"}
INTERPRETERS = {"python", "python3", "perl", "ruby", "node", "php"}
SQL_CLIENTS = {"sqlite3", "psql", "mysql", "mariadb", "duckdb", "sqlcmd"}
KEYWORDS = {"!", "{", "}", "then", "do", "else", "elif", "if", "while", "until", "time"}
GROUP_OPEN, GROUP_CLOSE = {"{", "do", "then"}, {"}", "done", "fi"}
# Markers left inside a word where a $(...), `...`, <(...) or >(...) was.
SUB, DOWNLOAD, RUNS_SHELL = "\x00sub\x00", "\x00download\x00", "\x00shell\x00"
SQL_DANGER = re.compile(r"\b(?:DROP\s+(?:TABLE|DATABASE|SCHEMA)\b|TRUNCATE\s+(?:TABLE\s+)?[\w\"`\[])", re.IGNORECASE)
# Options that take inline code: bash -c, python3 -c, node -e, perl -e, ruby -e, php -r.
CODE_FLAGS = {"python": "c", "python3": "c", "perl": "eE", "ruby": "e", "node": "ep", "php": "r"}
ALL_FILES = {".", "./", ":/", ":/.", "*", "./*", ":(top)"}  # git pathspecs meaning "everything"
NARROWING = {"-name", "-iname", "-path", "-ipath", "-wholename", "-iwholename", "-regex", "-iregex",
             "-newer", "-mtime", "-mmin", "-atime", "-amin", "-ctime", "-cmin", "-size", "-empty",
             "-user", "-group", "-perm", "-lname", "-ilname", "-inum", "-samefile", "-links"}
HOME = os.path.expanduser("~")
MAX_HEREDOCS = 200
COMMAND = ""


def block(reason):
    shown = COMMAND if len(COMMAND) <= 400 else COMMAND[:400] + " ..."
    print(f"BLOCKED ({reason}): {shown}", file=sys.stderr)
    print("This needs the human's explicit approval for the exact command. "
          "Propose a safer alternative or ask.", file=sys.stderr)
    sys.exit(2)


# ---------------------------------------------------------------- reading the command

class Cmd:
    """One simple command: its words, redirections, heredocs and pipeline."""
    def __init__(self, pipe):
        self.words, self.redirs, self.herestrings, self.heredocs = [], [], [], []
        self.pipe = pipe

    def empty(self):
        return not (self.words or self.redirs or self.herestrings or self.heredocs)


class Heredoc:
    def __init__(self, marker, strip_tabs, quoted):
        self.marker, self.strip_tabs, self.quoted = marker, strip_tabs, quoted
        self.body, self.closed = "", False


class Parser:
    def __init__(self, text):
        self.s = text
        self.cmds = []
        self.npipes = 0
        self.nheredocs = 0

    def new_cmd(self, pipe=None):
        if pipe is None:
            self.npipes += 1
            pipe = self.npipes
        cmd = Cmd(pipe)
        self.cmds.append(cmd)
        return cmd

    def parse(self, i=0, closer=None):
        """Read from i to the end, or to an unquoted `closer` at this level. Return the next index."""
        s = self.s
        state = {"cmd": self.new_cmd(), "word": [], "in_word": False, "redir": None, "piped": False}
        pending, depth = [], 0
        # Groups: ( ), { }, do ... done and then ... fi. Each entry is (first command, pipe it
        # inherits). A group before a pipe joins it (`(curl x) | sh`); a group after a pipe
        # shares it with every command inside (`curl x | { cd /tmp && sh; }`).
        groups, closed = [], [None]
        cases = [0]  # open case blocks: their `pattern)` must not end a $( ... )

        def inherited_pipe(cmd, opens_after_pipe):
            in_piped_group = bool(groups) and groups[-1][1] is not None
            return cmd.pipe if (opens_after_pipe and state["piped"]) or in_piped_group else None

        def end_word():
            if state["in_word"]:
                w, cmd, redir = "".join(state["word"]), state["cmd"], state["redir"]
                if not redir and not cmd.words and w in ("case", "esac"):
                    cases[0] = cases[0] + 1 if w == "case" else max(cases[0] - 1, 0)
                if not redir and not cmd.words and w in GROUP_OPEN:
                    groups.append((len(self.cmds) - 1, inherited_pipe(cmd, w == "{")))
                elif not redir and not cmd.words and w in GROUP_CLOSE and groups:
                    closed[0] = (groups.pop()[0], len(self.cmds))
                if redir == "<<<":
                    cmd.herestrings.append(w)
                elif redir:
                    cmd.redirs.append((redir, w))
                else:
                    cmd.words.append(w)
                state["redir"] = None
            state["word"], state["in_word"] = [], False

        def end_cmd(piped=False):
            end_word()
            inherit = groups[-1][1] if groups else None
            state["cmd"] = self.new_cmd(state["cmd"].pipe if piped else inherit)
            state["piped"] = piped

        def add(text):
            state["word"].append(text)
            state["in_word"] = True

        while i < len(s):
            c = s[i]
            nxt = s[i + 1] if i + 1 < len(s) else ""
            if c == "\\":
                if nxt == "\n":  # line continuation
                    i += 2
                    continue
                add(nxt)
                i += 2
            elif c == "'":
                j = s.find("'", i + 1)
                j = len(s) if j < 0 else j
                add(s[i + 1:j])
                i = j + 1
            elif c == "$" and nxt == "'":
                i = self.ansi_quote(i + 2, state["word"])
                state["in_word"] = True
            elif c == '"':
                i = self.double_quote(i + 1, state["word"])
                state["in_word"] = True
            elif c == "`":
                i = self.backtick(i + 1, state["word"])
                state["in_word"] = True
            elif c == "$" and nxt == "(":
                if s.startswith("$((", i) and self.arithmetic_at(i):
                    i = self.arithmetic(i + 3)
                    add(SUB)
                else:
                    i = self.substitution(i + 2, state["word"])
                    state["in_word"] = True
            elif c in "<>" and nxt == "(" and not state["in_word"]:
                i = self.substitution(i + 2, state["word"], process=True)
                state["in_word"] = True
            elif c == "#" and not state["in_word"]:
                j = s.find("\n", i)
                i = len(s) if j < 0 else j
            elif c in " \t":
                end_word()
                i += 1
            elif c == "\n":
                end_word()
                if not state["cmd"].empty():  # a line ending in | && || continues the command
                    end_cmd()
                i = self.heredoc_bodies(i + 1, pending)
                pending = []
            elif c == "(":
                depth += 1
                end_word()
                if not state["cmd"].empty():  # f() { ...; } or a stray (
                    end_cmd()
                groups.append((len(self.cmds) - 1, inherited_pipe(state["cmd"], True)))
                i += 1
            elif c == ")":
                end_word()  # first, so a word like `esac` right before the ) is counted
                if depth == 0 and closer == ")" and not cases[0]:
                    return i + 1
                depth = max(depth - 1, 0)
                if groups:
                    closed[0] = (groups.pop()[0], len(self.cmds))
                end_cmd()
                i += 1
            elif c == ";":
                end_cmd()
                i += 1
            elif c == "&":
                if nxt == ">":  # &> and &>> send stdout and stderr to a file
                    end_word()
                    state["redir"] = ">"
                    i += 3 if s.startswith("&>>", i) else 2
                else:
                    end_cmd()
                    i += 2 if nxt == "&" else 1
            elif c == "|":
                if nxt == "|":
                    end_cmd()
                    i += 2
                else:
                    end_word()
                    cur = state["cmd"]
                    group = closed[0] if (cur.empty() or (len(cur.words) == 1 and cur.words[0] in GROUP_CLOSE)) else None
                    end_cmd(piped=True)
                    if group:  # the whole group feeds the next stage
                        for k in range(*group):
                            self.cmds[k].pipe = state["cmd"].pipe
                    closed[0] = None
                    i += 2 if nxt == "&" else 1
            elif c in "<>":
                if state["in_word"] and "".join(state["word"]).isdigit():
                    state["word"], state["in_word"] = [], False  # 2>file: the 2 is a file descriptor
                else:
                    end_word()
                if s.startswith("<<<", i):
                    state["redir"] = "<<<"
                    i += 3
                elif s.startswith("<<", i):
                    i = self.heredoc_marker(i + 2, state["cmd"], pending)
                else:
                    op, i = c, i + 1
                    while i < len(s) and s[i] in ">|&":
                        op += s[i]
                        i += 1
                    m = re.match(r"\d+|-", s[i:i + 12]) if op.endswith("&") else None
                    if m:  # >&2, 2>&1: copies a file descriptor, no file involved
                        i += m.end()
                    else:
                        state["redir"] = op.rstrip("|&")
            else:
                add(c)
                i += 1
        end_word()
        return i

    def double_quote(self, i, word):
        s = self.s
        while i < len(s):
            c = s[i]
            if c == '"':
                return i + 1
            if c == "\\" and i + 1 < len(s):
                if s[i + 1] == "\n":
                    i += 2
                elif s[i + 1] in '"\\$`':
                    word.append(s[i + 1])
                    i += 2
                else:
                    word.append(c)
                    i += 1
            elif c == "`":
                i = self.backtick(i + 1, word)
            elif s.startswith("$((", i) and self.arithmetic_at(i):
                i = self.arithmetic(i + 3)
                word.append(SUB)
            elif s.startswith("$(", i):
                i = self.substitution(i + 2, word)
            else:
                word.append(c)
                i += 1
        return i

    def ansi_quote(self, i, word):
        s, start = self.s, i
        while i < len(s) and s[i] != "'":
            i += 2 if s[i] == "\\" else 1
        word.append(decode_escapes(s[start:i]))
        return i + 1

    def arithmetic_at(self, i):
        """Is the $(( at i arithmetic? Only if its two closing parens are adjacent.
        Otherwise it is $( followed by a subshell, as in $((git status) 2>&1)."""
        s, depth, j = self.s, 2, i + 3
        while j < len(s):
            if s[j] == "(":
                depth += 1
            elif s[j] == ")":
                depth -= 1
                if depth == 0:
                    return s[j - 1] == ")"
            j += 1
        return True

    def arithmetic(self, i):
        depth = 2
        while i < len(self.s) and depth:
            depth += {"(": 1, ")": -1}.get(self.s[i], 0)
            i += 1
        return i

    def substitution(self, i, word, process=False):
        """$(...), <(...) or >(...): its commands run too, so they are read and checked."""
        start = len(self.cmds)
        i = self.parse(i, closer=")")
        word.append(SUB + marks(self.cmds[start:], process))
        return i

    def backtick(self, i, word):
        s, j = self.s, i
        while j < len(s) and s[j] != "`":
            j += 2 if s[j] == "\\" else 1
        inner = Parser(s[i:j])
        inner.npipes = self.npipes  # keep pipeline numbers unique across both parsers
        inner.parse()
        self.npipes = inner.npipes
        self.cmds.extend(inner.cmds)
        word.append(SUB + marks(inner.cmds, False))
        return j + 1

    def heredoc_marker(self, i, cmd, pending):
        s = self.s
        strip_tabs = s.startswith("-", i)
        i += strip_tabs
        while i < len(s) and s[i] in " \t":
            i += 1
        marker, quoted = [], False
        while i < len(s) and s[i] not in " \t\n;&|<>()":
            if s[i] in "'\"":
                j = s.find(s[i], i + 1)
                j = len(s) if j < 0 else j
                marker.append(s[i + 1:j])
                quoted, i = True, j + 1
            elif s[i] == "\\":
                marker.append(s[i + 1:i + 2])
                quoted, i = True, i + 2
            else:
                marker.append(s[i])
                i += 1
        self.nheredocs += 1
        if self.nheredocs > MAX_HEREDOCS:
            block("too many heredocs to check")
        h = Heredoc("".join(marker), strip_tabs, quoted)
        cmd.heredocs.append(h)
        pending.append(h)
        return i

    def heredoc_bodies(self, i, pending):
        s = self.s
        for h in pending:
            lines = []
            while i < len(s):
                j = s.find("\n", i)
                j = len(s) if j < 0 else j
                line, i = s[i:j], j + 1
                if (line.lstrip("\t") if h.strip_tabs else line) == h.marker:
                    h.closed = True
                    break
                lines.append(line)
            h.body = "\n".join(lines)
        return min(i, len(s))

    def expansions(self):
        """Commands bash runs inside an unquoted heredoc body: $(...) and backticks."""
        s, i, sink = self.s, 0, []
        while i < len(s):
            if s[i] == "\\":
                i += 2
            elif s[i] == "`":
                i = self.backtick(i + 1, sink)
            elif s.startswith("$((", i) and self.arithmetic_at(i):
                i = self.arithmetic(i + 3)
            elif s.startswith("$(", i):
                i = self.substitution(i + 2, sink)
            else:
                i += 1
        return self.cmds


# ---------------------------------------------------------------- helpers

def peel(words):
    """Drop prefixes that do not change what runs. Returns (words, runs_as_root)."""
    w, i, root = words, 0, False

    def skip_options(i, with_value=(), value_letters=""):
        while i < len(w) and w[i].startswith("-"):
            takes_value = w[i] in with_value or (
                value_letters and re.fullmatch(rf"-[A-Za-z]*[{value_letters}]", w[i]))
            i += 2 if takes_value else 1
        return i

    while i < len(w):
        head = os.path.basename(w[i])
        if w[i] in KEYWORDS or re.match(r"^[A-Za-z_][A-Za-z0-9_]*=", w[i]):
            i += 1
        elif w[i] == "function":  # function name { ...; }
            i += 2
        elif head in ("command", "builtin", "nohup", "exec", "time", "noglob"):
            i = skip_options(i + 1)
        elif head == "env":
            i += 1
            while i < len(w) and (w[i].startswith("-") or "=" in w[i]):
                i += 2 if w[i] in ("-u", "-C", "-S", "-P") else 1
        elif head in ("sudo", "doas"):
            root = True
            i = skip_options(i + 1, value_letters="ugCDhprtUT")  # -u root, -iu postgres
        elif head == "timeout":
            i = skip_options(i + 1, ("-s", "-k", "--signal", "--kill-after")) + 1  # + the duration
        elif head == "nice":
            i = skip_options(i + 1, ("-n",))
        else:
            break
    return w[i:], root


def name_of(words):
    return os.path.basename(words[0]) if words else ""


def short_flags(args):
    return "".join(a[1:] for a in args if a.startswith("-") and not a.startswith("--"))


def decode_escapes(text):
    """Turn \\n, \\t and friends into the characters printf, echo -e and $'...' produce."""
    table = {"n": "\n", "t": "\t", "r": "\r", "\\": "\\", "'": "'", '"': '"', "a": "", "e": ""}
    return re.sub(r"\\(.)", lambda m: table.get(m.group(1), m.group(0)), text, flags=re.DOTALL)


def printed(name, args):
    """Roughly the text that echo or printf writes. Escapes are decoded to be safe."""
    if name == "echo":
        while args and re.fullmatch(r"-[neE]+", args[0]):
            args = args[1:]
        return decode_escapes(" ".join(args))
    if name == "printf":
        if args[:1] == ["-v"]:
            args = args[2:]
        if not args:
            return ""
        text, rest = args[0], list(args[1:])
        while rest and re.search(r"%[sbd]", text):
            text = re.sub(r"%[sbd]", lambda m: rest.pop(0).replace("\\", "\\\\"), text, count=1)
        return decode_escapes(" ".join([text] + rest))
    return ""


def output_of(cmds):
    """Text a group of commands clearly prints: echo, printf, or cat/tee of a heredoc."""
    out = []
    for c in cmds:
        w = peel(c.words)[0]
        if name_of(w) in ("echo", "printf"):
            out.append(printed(name_of(w), w[1:]))
        elif name_of(w) in ("cat", "tee"):
            out += [h.body for h in c.heredocs] + c.herestrings
    return "\n".join(t for t in out if t)


def ssh_remote(args):
    """The command ssh runs on the other machine (empty: it runs a shell that reads stdin)."""
    def skip(k):  # OpenSSH reads options before and after the host
        while k < len(args) and args[k].startswith("-"):
            if args[k] == "--":
                return k + 1
            k += 2 if re.fullmatch(r"-[A-Za-z]*[bcDEeFIiJLlmOopQRSWw]", args[k]) else 1
        return k
    return args[skip(skip(0) + 1):]


def marks(cmds, process):
    """Stands in for $(...) or <(...) inside a word: tags for "downloads" and "feeds a shell",
    then the text it prints, if that is known, on the next line."""
    real = [peel(c.words)[0] for c in cmds if c.words]
    tags = DOWNLOAD if any(name_of(w) in ("curl", "wget") for w in real) else ""
    if process and real and reads_stdin_as_code(real[0]):
        tags += RUNS_SHELL
    out = output_of(cmds)
    return tags + ("\n" + out if out else "")


def reads_stdin_as_code(w):
    """True for `bash`, `sh -s`, `bash /dev/stdin`, `python3 -` and the like."""
    name, args = name_of(w), w[1:]
    if name in SHELLS:
        code, inline = program(name, args)
        return "-s" in args or (not inline and code in ("", "-", "/dev/stdin"))
    if name == "ssh":  # `ssh host` or `ssh host 'bash -s'` runs what it is fed
        remote = ssh_remote(args)
        if not remote:
            return True
        parser = Parser(" ".join(remote))
        parser.parse()
        first = next((c.words for c in parser.cmds if c.words), [])
        return bool(first) and reads_stdin_as_code(peel(first)[0])
    return name in INTERPRETERS and (not args or args[0] in ("-", "/dev/stdin"))


def is_shell_script(text):
    """A file written earlier is checked as bash only if nothing says it is another language."""
    first = text.lstrip("\n").split("\n", 1)[0]
    return not (first.startswith("#!") and re.search(r"python|node|perl|ruby|php|deno|bun", first))


def wipes_everything(target):
    t = re.sub(r"^(?:~|\$HOME|\$\{HOME(?:[:?+=-][^}]*)?\})(?=/|$)", "~", target)
    if HOME not in ("", "/") and (t == HOME or t.startswith(HOME + "/")):
        t = "~" + t[len(HOME):]
    t = re.sub(r"/\.?\*$", "", t).rstrip("/") or "/"
    return (t in {"/", "~", "*", ".", "..", ".*"}
            or re.fullmatch(r"/[^/]+", t) is not None
            or re.fullmatch(r"/(?:Users|home)/[^/]+", t) is not None)


def downloaded_files(name, args, redirs):
    """Files that this curl or wget writes to disk."""
    urls = [a for a in args if re.match(r"(?:https?|ftp)://", a)]
    try:
        remote = (os.path.basename(urlparse(urls[0]).path) or "index.html") if urls else ""
    except ValueError:  # a URL Python cannot parse
        remote = ""
    files = [t for op, t in redirs if op.startswith(">")]
    i = 0
    while i < len(args):
        a = args[i]
        value = args[i + 1] if i + 1 < len(args) else ""
        if name == "curl":
            if a in ("-o", "--output") or (re.fullmatch(r"-[A-Za-z]*o", a)):
                files.append(value)
                i += 1
            elif a.startswith("--output="):
                files.append(a.split("=", 1)[1])
            elif a == "--remote-name" or re.fullmatch(r"-[A-Za-z]*O[A-Za-z]*", a):
                files.append(remote)
        elif name == "wget":
            if a in ("-O", "--output-document") or re.fullmatch(r"-[A-Za-z]*O", a):
                files.append(value)
                i += 1
            elif a.startswith("--output-document="):
                files.append(a.split("=", 1)[1])
            elif re.fullmatch(r"-[A-Za-z]*O.+", a):
                files.append(a[a.index("O") + 1:])
        i += 1
    if name == "wget" and not any(a in ("-O", "--output-document") or a.startswith("--output-document=")
                                  or re.fullmatch(r"-[A-Za-z]*O.*", a) for a in args):
        files.append(remote)
    return {os.path.basename(f) for f in files if f and f != "-"}


def program(name, args):
    """What a shell or interpreter runs: (inline code or script path, True if inline)."""
    flags = "c" if name in SHELLS else CODE_FLAGS.get(name, "")
    i = 0
    while i < len(args):
        a = args[i]
        if a in ("-o", "+o", "-O", "+O", "-m", "-W", "-X"):  # options that take a value
            i += 2
            continue
        if flags and a.startswith("-") and not a.startswith("--") and any(f in a[1:] for f in flags):
            return (args[i + 1] if i + 1 < len(args) else ""), True
        if a == "-" or not a.startswith(("-", "+")):
            return a, False
        i += 1
    return "", False


def runs_file(w, files):
    """Name of a file from `files` that this command runs, if any."""
    if not w or not files:
        return None
    if "/" in w[0] and os.path.basename(w[0]) in files:
        return os.path.basename(w[0])
    name = name_of(w)
    script = ""
    if name in SHELLS | INTERPRETERS:
        code, inline = program(name, w[1:])
        script = "" if inline else code
    elif name in ("source", ".") and len(w) > 1:
        script = w[1]
    return os.path.basename(script) if script and os.path.basename(script) in files else None


# ---------------------------------------------------------------- the rules

def check_git(args):
    i = 0
    while i < len(args) and args[i].startswith("-"):  # global options such as -C <dir>
        i += 2 if args[i] in ("-C", "-c", "--git-dir", "--work-tree", "--namespace", "--config-env") else 1
    if i >= len(args):
        return
    sub, a = args[i], args[i + 1:]
    short = short_flags(a)
    everything = any(x in ALL_FILES for x in a)
    if sub == "reset" and "--hard" in a:
        block("hard reset")
    if sub == "push" and ("f" in short or any(x in ("--force", "--mirror") or x.startswith("--force-with-lease")
                                              or (x.startswith("+") and len(x) > 1) for x in a)):
        block("force push")
    if sub == "checkout" and (everything or "f" in short or "--force" in a):
        block("discard local changes")
    if sub == "restore" and everything:
        staged_only = ("--staged" in a or "S" in short) and not ("--worktree" in a or "W" in short)
        if not staged_only:
            block("discard local changes")
    if sub == "clean" and ("f" in short or "--force" in a) and not ("n" in short or "--dry-run" in a):
        block("delete untracked files")
    if sub == "stash" and a[:1] == ["clear"]:
        block("delete all stashes")


def check_command(w, root):
    name, args = name_of(w), w[1:]
    if name == "rm":
        if root:
            block("delete as root")
        targets, flags, options = [], "", True
        for a in args:
            if options and a == "--":
                options = False
            elif options and a.startswith("--"):
                flags += {"--recursive": "r", "--force": "f"}.get(a, "")
            elif options and a.startswith("-") and len(a) > 1:
                flags += a[1:]
            else:
                targets.append(a)
        if "r" in flags.lower() and "f" in flags and any(wipes_everything(t) for t in targets):
            block("delete from root, home or everything")
    if name == "find" and "-delete" in args:
        k = 0
        while k < len(args) and args[k] in ("-H", "-L", "-P"):
            k += 1
        starts = []
        for a in args[k:]:
            if a.startswith("-") or a in ("(", ")", "!"):
                break
            starts.append(a)
        narrowed = any(a in NARROWING and (j == 0 or args[j - 1] not in ("-not", "!"))
                       for j, a in enumerate(args))
        if any(wipes_everything(s) for s in starts) and not narrowed:
            block("delete from root, home or everything")
    if name == "chmod" and ("R" in short_flags(args) or "--recursive" in args) \
            and any(a in ("777", "0777", "a+rwx", "ugo+rwx") for a in args):
        block("world-writable permissions")
    if name in ("mkfs", "newfs") or name.startswith(("mkfs.", "newfs_")):
        block("format a disk")
    if name == "diskutil" and any(a.lower() in (
            "erasedisk", "erasevolume", "zerodisk", "randomdisk", "secureerase", "partitiondisk", "reformat")
            for a in args[:2]):
        block("format a disk")
    if name == "dd" and any(a.startswith("of=/dev/") and a not in (
            "of=/dev/null", "of=/dev/stdout", "of=/dev/stderr") for a in args):
        block("overwrite a disk")
    if name == "git":
        check_git(args)


def check_cmds(cmds, depth, root_before=False):
    cmds = [c for c in cmds if not c.empty()]
    peeled = [peel(c.words) for c in cmds]
    # For each command, what a later stage of its pipeline does with its output:
    # runs it as code (any language), runs it as shell code, runs it as root.
    after = {"code": [], "bash": [], "root": [], "procsub": []}
    seen = {k: {} for k in after}
    for idx in range(len(cmds) - 1, -1, -1):
        c, (w, as_root) = cmds[idx], peeled[idx]
        for k in after:
            after[k].append(seen[k].get(c.pipe, False))
        if w and reads_stdin_as_code(w):
            seen["code"][c.pipe] = True
            seen["root"][c.pipe] = seen["root"].get(c.pipe, False) or as_root
            if name_of(w) in SHELLS or name_of(w) == "ssh":
                seen["bash"][c.pipe] = True
        if any(RUNS_SHELL in x for x in c.words + [t for _, t in c.redirs]):
            seen["procsub"][c.pipe] = True
    for k in after:
        after[k].reverse()
    code_after, bash_after, root_after, shell_after = after["code"], after["bash"], after["root"], after["procsub"]

    written, downloaded, fetching, pipe_text = {}, set(), set(), {}

    def record(op, target, text):  # a file this command line writes, in case it is run later
        key = os.path.basename(target)
        written[key] = written.get(key, "") + "\n" + text if op == ">>" else text

    for idx, c in enumerate(cmds):
        w, as_root = peeled[idx]
        root = root_before or as_root
        name, args = name_of(w), w[1:]
        piped_to_code = code_after[idx]
        piped_to_bash = bash_after[idx] or shell_after[idx]
        piped_root = root or root_after[idx]  # cat <<EOF | sudo bash
        feeds_shell = any(RUNS_SHELL in x for x in c.words + [t for _, t in c.redirs])
        more = depth + 1
        # cat FILE prints a file this command line wrote or downloaded earlier.
        files_read = [os.path.basename(a) for a in args if not a.startswith("-")] if name == "cat" else []
        if any(f in downloaded for f in files_read) and (piped_to_code or shell_after[idx]):
            block("run a download as code")
        file_text = "\n".join(written[f] for f in files_read if f in written)
        if file_text and piped_to_bash:
            check_text(file_text, more, piped_root)
        piped_in = pipe_text.get(c.pipe)  # what earlier stages printed, if this is a later stage
        pipe_text[c.pipe] = "\n".join(t for t in (piped_in, output_of([c]), file_text) if t)[-100_000:]

        # Running a download, or running a file this command line wrote or downloaded.
        if w and DOWNLOAD in w[0]:  # $(curl ...) used as the command itself
            block("run a download as code")
        if name in ("curl", "wget") and (piped_to_code or feeds_shell or shell_after[idx]):
            block("run a download as code")
        if name in SHELLS | INTERPRETERS:
            code, inline = program(name, args)
            if DOWNLOAD in code:
                block("run a download as code")
            if name in SHELLS and (inline or SUB in code):  # bash -c '...', bash <(echo ...)
                check_text(code, more, root)
        if name in ("eval", "source", ".") and args:
            if any(DOWNLOAD in a for a in args):
                block("run a download as code")
            if name == "eval" or SUB in args[0]:
                check_text(" ".join(args) if name == "eval" else args[0], more, root)
        if name == "ssh" and ssh_remote(args):  # ssh host 'command' runs it on the other machine
            check_text(" ".join(ssh_remote(args)), more)
        # What reads this command's stdin: a shell (bash, source, ssh host) or any language.
        shell_stdin = name in SHELLS | {"source", "."} or (name == "ssh" and reads_stdin_as_code(w))
        stdin_code = shell_stdin or reads_stdin_as_code(w)
        fed_in = [t for op, t in c.redirs if op == "<"]  # bash < x.sh, bash < <(echo ...)
        fed = [os.path.basename(t) for t in fed_in]
        for t in fed_in:
            if SUB in t and stdin_code:
                if DOWNLOAD in t:
                    block("run a download as code")
                if shell_stdin:
                    check_text(t, more, root)
        if runs_file(w, downloaded) or (stdin_code and any(f in downloaded for f in fed)):
            block("run a download as code")
        ran = runs_file(w, written) or (shell_stdin and next((f for f in fed if f in written), None))
        if ran and name not in INTERPRETERS and (name in SHELLS or is_shell_script(written[ran])):
            check_text(written[ran], more, root)
        if name in ("curl", "wget"):
            downloaded |= downloaded_files(name, args, c.redirs)
            fetching.add(c.pipe)
        elif piped_in is not None:  # a later stage saving what came down the pipe: tee x.sh, cat > x.sh
            saved = [(op, t) for op, t in c.redirs if op.startswith(">") and name in ("tee", "cat")]
            if name == "tee":
                saved += [(">>" if "-a" in args else ">", a) for a in args if not a.startswith("-")]
            saved = [(op, t) for op, t in saved if t not in ("/dev/null", "-")]
            if c.pipe in fetching:  # curl ... | tee install.sh
                downloaded |= {os.path.basename(t) for _, t in saved}
            for op, t in saved:
                record(op, t, piped_in)
        if name in ("echo", "printf") and (piped_to_bash or feeds_shell):
            check_text(printed(name, args), more, piped_root)

        check_command(w, root)

        # SQL reaches a database client through its arguments, a heredoc or here-string,
        # or text printed into it by an earlier stage (echo, printf, cat <<EOF).
        if name in SQL_CLIENTS:
            sql = [a[2:] if re.match(r"-[A-Za-z]", a) else a for a in args]  # -e"DROP ..."
            sql += c.herestrings + [h.body for h in c.heredocs] + fed_in + [written.get(f, "") for f in fed]
            for a in args:  # psql -f drop.sql, --file=drop.sql, -fdrop.sql
                for name_part in (a, a.split("=", 1)[-1], a[2:] if re.match(r"-[A-Za-z]", a) else ""):
                    sql.append(written.get(os.path.basename(name_part), "") if name_part else "")
            sql.append(piped_in or "")  # echo, printf, cat <<EOF or cat FILE earlier in the pipe
            if SQL_DANGER.search("\n".join(sql)):
                block("drop or truncate database data")

        # Heredocs and here-strings are code when a shell reads them, otherwise data.
        code = shell_stdin or feeds_shell or piped_to_bash
        targets = [(op, t) for op, t in c.redirs if op.startswith(">")]
        if name == "tee":
            targets += [(">>" if "-a" in args else ">", a) for a in args if not a.startswith("-")]
        for h in c.heredocs:
            if code or not h.closed:
                check_text(h.body, more, piped_root)
            elif not h.quoted:
                check_cmds(Parser(h.body).expansions(), more, root)
            for op, t in targets:
                record(op, t, h.body)
        for text in c.herestrings:
            if code:
                check_text(text, more, piped_root)
            if name in ("cat", "tee"):
                for op, t in targets:
                    record(op, t, text)
        if name in ("echo", "printf"):
            for op, t in c.redirs:
                if op.startswith(">"):
                    record(op, t, printed(name, args))


def check_text(text, depth=0, root=False):
    if depth > 4:
        block("command nested too deeply to check")
    parser = Parser(text)
    parser.parse()
    check_cmds(parser.cmds, depth, root)


def main():
    global COMMAND
    raw = sys.stdin.read()
    payload = json.loads(raw) if raw.strip() else {}
    tool_input = payload.get("tool_input", {})
    command = tool_input.get("command", "")
    if not isinstance(command, str):
        raise TypeError("command is not text")
    COMMAND = command
    if command.strip():
        check_text(command)
    sys.exit(0)


if __name__ == "__main__":
    main()
