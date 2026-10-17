# Build a factory, not a shortcut

Most people meet AI as a shortcut. You paste a prompt, you get a good answer, you save twenty minutes. Next week you need the same thing, so you find the prompt again, paste it again, fix the same mistakes again. The shortcut never gets better, and it never runs without you.

I run my content, two YouTube channels and three SEO projects with a handful of AI agents. What changed for me was not a better prompt. It was treating every repeat job like a station in a small factory: it takes a file in, puts a file out, gets checked by someone other than the maker, and leaves a receipt. Once a job works like that, it can run on a schedule, and the next station can pick up its output without me in the middle.

This page explains the idea with my own content line as the example, then shows how to start one with the packs in this repo.

## A station is a small skill with a file on each side

A station is one skill that does one job. It reads a named input file, writes a named output file and says what "done" means. Nothing lives only in a chat window.

That sounds boring, and it is the point. A chat remembers nothing tomorrow. A file does. When the writer station leaves `draft.md` in a folder, the review station can read it next hour or next week, even after the chat that wrote it is gone. When something breaks, you open the file and see where.

Each station also has one owner. Two agents writing the same file at the same time is the fastest way to lose work, so one station writes a file and every other station only reads it.

## My content line, station by station

This is the line that makes most of my posts. Every arrow is a file in a folder.

1. **Radar.** A scheduled job reads public posts from creators I follow and marks the outliers, meaning posts that did several times better than that creator's normal. It writes a short list with links.
2. **Bank.** Every few days a read-only reader collects the AI guides and threads that people actually saved and shared, and adds them to a private content bank with one line on how I could do my own version.
3. **Writer.** Claude drafts from that list plus my own receipts of real work. The rule is to keep what made the outlier work (topic, hook shape, length, visual type) and change everything else to my real case, in my words. No copying sentences, images or footage.
4. **Roast.** A different model, Codex, reviews every draft read-only and must return PASS before anything moves on. It checks the hook against what the post delivers, the facts, the tone and the usual AI tells. One of my quote posts failed for "empty praise" and "generic advice", got rewritten to name the other builder's feature and ask how he checked the calls, and then passed.
5. **One approval.** I look once at a review page with the finished batch and tick or skip. I don't approve each step on the way, only the thing that goes public.
6. **Schedule and post.** Approved posts get a time slot. A scheduled run posts them, checks it hasn't already posted the same thing, and writes down the live link.
7. **Receipts and a weekly look back.** Every run leaves a receipt with what it did and a STATUS line: verified, unverified or broken. On Monday a report reads the numbers and the receipts, and whatever I changed or rejected becomes a rule in the skill that same day, so I never have to say it twice.

None of these stations is clever on its own. The value is that each one hands a checked file to the next, so the line keeps moving while I'm doing something else.

## Rules that keep the factory running

**A different model checks the work.** The model that wrote something is bad at seeing its own gaps. I use Claude to make things and Codex to review them, and when Codex is down a fresh Claude with no chat history does the review instead. The maker never approves its own work.

**You approve at the doors that only open one way.** Sending, posting, paying, deploying and deleting wait for a person. Drafting, testing, fixing and reviewing don't. Put your approval at the end of the line on the finished thing, not in the middle of every step, or you become the bottleneck you were trying to remove.

**Let the agent figure it out once, then make it a script.** The first time I uploaded a video batch, a browser agent clicked through YouTube Studio. One upload took about 16.3M Codex tokens and 134 browser steps, because every step re-sent the whole chat history. Now one Python script does the same job through the YouTube API with no model in the loop. Agents are great at working out a new job. Once the job is known, turn it into code that runs the same way every time.

**Every correction patches the station.** When I fix a draft by hand and don't fix the skill, the same mistake comes back next week. So feedback goes into the skill or its checklist the same day. The next run gets the updated checklist, and the reviewer checks whether the correction held.

**Receipts beat memory.** "Done" from an agent means nothing until you can see it. A receipt names the file, the check that ran and its result. If a run can't prove something, it says UNVERIFIED and why, instead of saying done.

## Start your own factory

You don't need ten stations. Start with one job you already do every week.

1. **Pick the job.** Something with a clear input and output, like turning call notes into a follow-up draft, or a weekly sales summary from a chat export.
2. **Write it as a skill.** Install a pack from this repo, or copy the shape of one: what to give it, the steps, what comes back and how to check it.
3. **Give it a folder and a receipt.** Input file in, output file out, and a short receipt with a STATUS line at the end. The `evidence-loop` and `job-packet` skills in `aiwos-core` do this part.
4. **Add a second check.** A different model, or at least a fresh session, reviews the output before you use it. `cross-model-review` in `aiwos-handoff` is built for this.
5. **Run it on a schedule.** Once it has passed a few times, let it run on its own and only look at the receipt.
6. **Chain the next station.** When you trust the first one, point the next job at its output file. That's the factory.

Run each station by hand until it's boring, then automate it. A station you never ran by hand will fail in ways you can't read.

## What a factory won't do

It won't decide what's worth making. Taste, money calls, legal wording and anything with your name on it stay with you. It also won't fix a bad process. If the job is unclear when you do it by hand, an agent will just do the unclear thing faster.

What it does is take the repeat work off your desk and leave proof behind, so you spend your time on the decisions only you can make.

The `aiwos-factory` pack in this repo adds stations you can copy straight away. Its first one, `motion-explainer`, turns a script into a scene-by-scene brief for HTML explainer videos, with the review loop built in. See [packs.md](packs.md).
