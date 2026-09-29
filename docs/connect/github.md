# Connecting GitHub

Checked on 30 Sep 2026 with gh 2.98.0 (`gh --version` and `gh auth login --help`). The permission guidance below was checked against [GitHub's personal access token docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) and the [GitHub CLI login manual](https://cli.github.com/manual/gh_auth_login) on **2026-09-30**. This is a documentation check, not a live account or write-action test.

## What connecting GitHub lets an agent do

Two official routes:

1. **The `gh` CLI** lets an agent use GitHub from a terminal with commands such as `gh issue list` and `gh pr view`.
2. **The official GitHub MCP server** ([github/github-mcp-server](https://github.com/github/github-mcp-server), MIT) exposes GitHub as MCP tools.

Either route can read repos, issues and pull requests, subject to the credential's permissions and the available tools. Write access does not give an agent permission to act: the ask-first rules below still apply.

## Official steps

**Route 1 — `gh` CLI:**

`gh auth login` requests broad scopes by default. Its local help states exactly:

> The minimum required scopes for the token are: `repo`, `read:org`, and `gist`.

That minimum-scopes line describes a classic personal access token passed with `--with-token`; it is not the permission model for a fine-grained token. The usual interactive login is:

```bash
gh auth login
```

Follow the prompts in your own terminal and browser. Do not paste a token into an agent's chat.

**Narrower route — a fine-grained personal access token:**

Follow [GitHub's token creation instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token) (checked **2026-09-30**). Choose the resource owner, **Only select repositories**, the repos needed for the job, an expiry and only the required permissions. Start with read-only permissions for reading work. GitHub documents feature and organization restrictions; check those before choosing permissions.

Export the token as `GH_TOKEN` in **your own shell**, then launch the agent from that shell. For example, in Bash, this hidden prompt keeps the value out of shell history and terminal output:

```bash
read -r -s -p 'GitHub token: ' GH_TOKEN
printf '\n'
export GH_TOKEN
```

Never paste the value into chat, a command argument, a receipt or a committed file. The CLI's help recommends `GH_TOKEN` for fine-grained tokens instead of `gh auth login --with-token`.

Check authentication without printing the token:

```bash
gh auth status
```

Do not add `--show-token`. For fine-grained tokens, review repository access and permissions in GitHub's token settings; OAuth scope names are not a substitute for that check.

**Route 2 — official GitHub MCP server:**

Follow the current setup instructions in [github/github-mcp-server](https://github.com/github/github-mcp-server). Its README covers a hosted server and a local Docker option. Limit the credential and available tools to the work you intend. In Claude Code, an installed MCP server appears in `/mcp`.

## What stays blocked / asks first

These actions always require your explicit approval under `template/AGENTS.md` §5, through the CLI, MCP or API:

- **Pushing** to any remote branch, including a branch that triggers a preview or production deploy.
- **Opening a pull request, creating an issue or commenting on a public repo.**
- **Force-pushing, deleting a repo or branch, or changing repo visibility.**
- **Merging into a production or release branch**, after you review the diff.
- **Creating a repo, transferring ownership or changing account access.**

A token limited to selected repos reduces access; it does not replace approval for a write.

## Read-only test prompt

Ask the agent: **"Using GitHub, list the last 5 commits on the current repo and check `gh auth status` without `--show-token`. Report authentication state only. Don't push, open a PR, create an issue, comment or change anything."** The expected result is commit data and authentication state, with no token value and no write call. This prompt is provided for you to test; it was not live-tested during this documentation check.
