---
name: video-brief
description: "Turn a real job or piece of work into a 30-60 second video script, shot list, on-screen text and caption rules, ready to hand to HyperFrames or a similar video builder. Use when someone wants a short video made from real work but has not yet written a script or shot list. Never renders or publishes video."
---

# Video brief

Thin on purpose: this skill turns a real job into a brief. The actual video build, rendering and effects belong to a dedicated video tool, such as [HyperFrames](https://github.com/heygen-com/hyperframes) (optional, Apache-2.0). Without a video tool, save the brief for a person to use later.

## What this produces

From one real, sanitised job or piece of work: a 30–60 second script broken into beats, a matching shot list, the on-screen text for each beat, and a set of caption rules. This brief is the input to a video builder — it does not render anything itself.

The caption checker ships beside this SKILL.md at `scripts/check-captions.py`. Resolve that path from this skill's installed folder, regardless of the current working directory. Run `python3 "<this skill's folder>/scripts/check-captions.py" "<caption-file.srt>"` (or a `.vtt` file). It works with a skills-only plugin install and needs Python 3. If Python 3 is unavailable, report that the captions have not been linted and leave the checker step pending.

## Before you start

- On the first run, use a made-up example. For real material, **clean locally first** before pasting into any AI: remove names, IC numbers, phone numbers, bank details and addresses locally in your own editor; keep only the facts the brief needs.
- `safe-to-paste` is an optional second check from the default `aiwos-business` pack, after local cleaning. If that dependency is missing in a video-only installation, use a made-up example or already-cleaned facts and manually check for remaining identifying details before continuing. It is not an upload barrier.
- The one thing the video should make a viewer feel or understand by the end.
- Roughly how long the final video should be (30s, 45s or 60s) and whether it needs captions burned in (assume yes for social).

## Steps

1. **Pick the one idea.** A 30–60 second video can carry one idea well, not three. State it in one sentence before writing anything else.
2. **Break it into beats.** 4–8 beats for a 30–60s video (roughly 5–10 seconds each): hook, problem, what was done, result, close. Each beat gets one line of narration or on-screen text, not a paragraph.
3. **Write the shot list.** For each beat: what is on screen (real footage, a screen recording, a title card, a simple graphic) — described plainly enough that someone else could shoot or build it without guessing.
4. **Write the on-screen text** for each beat, matched to what a viewer reads in the 3–5 seconds that beat is on screen — short enough to read at normal reading speed (see caption rules below).
5. **Set the caption rules** for this video, to be checked by the beta `check-captions.py` lint once captions exist (then still play the file in your video tool before publishing):
   - Max characters per line: 42 (a common readable limit for burned-in captions).
   - Max lines per cue: 2.
   - Reading speed: no more than about 20 characters per second of cue duration (roughly 3 words per second at typical word length).
   - No overlapping cues, and no cue that ends before it starts.
   - No ASCII control characters inside cue text; tabs and ordinary line endings are allowed.
6. **Hand off.** Output the finished script, shot list, on-screen text and caption rules as one document, ready to paste into HyperFrames or another video builder. This skill stops here — it does not render, render-check or publish video.

## Worked example

Idea: "A five-minute morning sort stopped enquiries getting lost overnight."
Beats: 1) Hook — a phone buzzing with unread messages. 2) Problem — "enquiries piled up overnight, nobody sorted them till noon." 3) Fix — "a five-minute morning sort: Hot, Warm, Later." 4) Result — "nothing left unsorted by 9am, three weeks running." 5) Close — "the fix wasn't a faster reply. It was seeing the queue."
Shot list: beat 1 = screen recording of a phone lock screen with notifications; beats 2–4 = simple title cards with the line as text; beat 5 = title card, slower pace.

## Failure modes

- Do not write a script that needs more than one idea to land — cut, don't cram.
- Do not write on-screen text a viewer cannot read in the beat's on-screen time at normal reading speed.
- Do not invent a shot, statistic or claim the real job does not support.
- Do not attempt to render, encode or publish video from this skill — hand the finished brief to a video builder instead.

## Human approval

**This skill only produces a script, shot list, on-screen text and caption rules — a document, not a video. It never renders, publishes, uploads or posts anything; a person reviews the brief before handing it to a video builder, and approves the finished video before it is posted anywhere.**
