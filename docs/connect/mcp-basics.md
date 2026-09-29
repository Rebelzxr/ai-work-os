# MCP basics

Checked against Anthropic's own Claude Code docs and the Model Context Protocol site on **29 September 2026**.

## What this is

MCP (Model Context Protocol) is the open standard both Claude Code and Codex use to connect an agent to an outside tool — GitHub, Gmail, Vercel, a database, Telegram — as a set of typed function calls the agent can see and call, instead of the agent trying to drive a website by guesswork. See the protocol's own site: <https://modelcontextprotocol.io> and Claude Code's MCP docs: <https://docs.claude.com/en/docs/claude-code/mcp>.

## What connecting an MCP server does and does not do

- **Does:** gives the agent a fixed list of named actions for that tool (for example, GitHub's server exposes actions like "list issues" or "create a pull request") and, for most servers, a fixed list of read-only resources it can look at.
- **Limits what the agent can call, not what it can see.** The agent can only use the actions the server's author defined, but anything those actions return (a file, an email, a page, sometimes a token or a cookie if the server is badly built) lands in the agent's context and is sent to the AI model. Pick servers from sources you trust, read what their tools return, and scope them to the least they need (a specific repo, a specific board) rather than your whole account. Never paste a password or token into chat to "help" a server connect.
- **Does not** make an action automatic. Whether Claude Code or Codex asks before running a given tool call is a separate permission setting from whether the server is connected at all — see `template/AGENTS.md` §5 for the actions this workspace always asks about regardless of what a connected server allows.

## Connecting a server (the general shape)

The exact command differs per tool (see `github.md` and `telegram.md` for two worked examples), but the pattern is the same in both Claude Code and Codex:

1. **Official install command** from the tool's own docs — usually a CLI login (`gh auth login`) or an OAuth flow inside the agent's own settings UI, never a token typed into chat.
2. **The agent lists what's now available**: in Claude Code, `/mcp` shows connected servers; `claude mcp list` from a terminal does the same outside a session.
3. **Test with a read-only action first** (see each guide's "test prompt" section) before trusting the connection with anything that writes.

## What stays blocked regardless of connection

Connecting a server is not the same as authorising every action it can perform. `template/AGENTS.md` names the actions that always need your explicit yes, no matter which MCP server offers them: a production deploy or purchase, sending or forwarding an email, sending a message, deleting or changing DNS records. A connected server that *can* do these things does not mean an agent working in this workspace *will* do them without asking — that boundary is enforced by the workspace's own rules file and your own review of what an agent proposes, not by the server itself.

## Read-only test prompt

Once any MCP server is connected, ask the agent: **"List what you can currently see through <server name>, but don't change anything."** A properly scoped server answers with a list (issues, files, recent messages — whatever it exposes for reading) and takes no action. If the agent instead does something irreversible on the first ask, stop and check the server's own scope settings before using it again.
