# Connecting agents to real tools

Each page here explains one connection: what it lets an agent do, the exact official steps (verified against the vendor's own docs, with the check date), what stays blocked and needs your approval, and a read-only test prompt that proves the connection works without doing anything to your account.

None of these pages ever ask you to paste a token, password or API key into chat. Use the tool's own OAuth flow, its CLI's own login command, or your password manager's own integration where one exists.

## Shipped (phase 2, checked 29 September 2026)

| Guide | What it connects |
|---|---|
| [mcp-basics.md](mcp-basics.md) | What an MCP server is, how Claude Code and Codex connect to one, and the read-only-first habit that applies to every guide below |
| [github.md](github.md) | GitHub, through the `gh` CLI or the official GitHub MCP server |
| [telegram.md](telegram.md) | A Telegram bot, for read-only notifications and approvals |

## Coming later (not yet in this repo)

These need a clean test account to verify against, which this build could not set up unattended. Until a page ships here, use each vendor's own official docs directly:

- **Google** (Gmail, Calendar, Drive) — official docs: <https://developers.google.com/workspace>
- **Notion** — official docs: <https://developers.notion.com>
- **Vercel** — official docs: <https://vercel.com/docs/mcp>
- **Cloudflare** — official docs: <https://developers.cloudflare.com/agents>

`scripts/doctor.sh` does not yet check these connections' pages for staleness — the check date printed on each shipped page above is the freshness signal for now.
