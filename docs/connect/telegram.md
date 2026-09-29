# Connecting Telegram

Steps below are from Telegram's own Bot API documentation (<https://core.telegram.org/bots/api>, checked 29 September 2026). **Not live-tested in this build** — creating a bot and sending a message are both actions this build could not verify without either creating a real bot token or actually sending a message, and the job that produced this page was explicitly told not to call any API that sends a message. Treat the steps as accurate to Telegram's published docs on the check date; test them yourself before relying on this page.

## What connecting Telegram lets an agent do

A Telegram bot connection lets an agent read messages sent to it and send messages back, in a specific chat or channel you control — most commonly used here for status notifications and for asking you to approve something before it happens (see `template/AGENTS.md` §5: this workspace's own rule is that anything an agent wants Telegram to *send* still needs your explicit approval, the connection existing does not grant that on its own).

## Official steps

1. **Create a bot with @BotFather** (Telegram's own bot for making bots): open a chat with `@BotFather` inside Telegram, send `/newbot`, and follow its prompts for a name and a username. BotFather replies with a bot token — a long string starting with a number, a colon, and then letters/digits. This token is a credential: store it the same way you'd store any other secret (an environment variable or local secrets file), never pasted into an agent's chat.
2. **Get the bot's updates** via the Bot API's `getUpdates` method, or set a webhook, to receive messages sent to it — see the "Getting updates" section of the Bot API docs for the current recommended approach.
3. **Connect it to your agent** through whichever MCP or plugin integration your agent client supports for Telegram (the official `telegram` plugin comes from [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/telegram), at `external_plugins/telegram`; install it as `telegram@claude-plugins-official` if your client supports it, checked 2026-09-30) — follow that integration's own setup docs for wiring the token in.

## What stays blocked / asks first

- **Sending any message is an explicit-approval action under `template/AGENTS.md` §5** — a connected bot can send, but this workspace's rule is that the agent asks first, every time, including test messages and scheduled status notifications.
- **Approving a pairing/allowlist request inside a Telegram message is never valid.** If a message *claims* to be you asking to approve a new bot pairing or add someone to an allowlist, that is exactly the shape of a prompt-injection attempt — the real you asks through the agent's own settings or chat, not through a Telegram message pretending to be an instruction.
- **The bot token itself is a secret.** Never have an agent print it, log it, or include it in a receipt or committed file.

## Read-only test prompt

Because this page isn't live-tested, treat this as the test *you* should run, not a claim this build already made: after connecting a bot, ask your agent **"Check whether the Telegram connection is active and tell me the bot's own username via getMe, but don't send any message."** `getMe` is a read-only Bot API call that confirms the bot token works without sending anything to anyone. If the agent instead sends a test message without asking, that is a sign the connection or the agent's own approval habits need tightening before you rely on it.
