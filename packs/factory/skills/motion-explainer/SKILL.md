---
name: motion-explainer
description: "Turn a finished, fact-checked script into a locked look, a scene-by-scene motion brief, one build brief per chapter for sub-agents, and a render-and-review checklist for HTML explainer videos (HyperFrames or a similar HTML-to-video tool). Use when a long explainer or a Short already has its script and needs to be built as motion graphics. Never renders, uploads or publishes video itself."
---

# Motion explainer

One station in a content factory: the script comes in, a build-ready brief comes out, and a separate reviewer checks the build before anyone uploads it. The method comes from a working explainer-video line. The style below is one example look; swap in your own and keep the rules.

For a 30–60 second piece that still needs its script, run `video-brief` from `aiwos-video` first. This skill starts where a finished script exists, at any length.

The build itself belongs to an HTML-to-video tool such as [HyperFrames](https://github.com/heygen-com/hyperframes) (optional, Apache-2.0). Without one, the brief is still useful to a human motion designer.

## What to give it

- The finished script, with narration split into lines or beats. It should already be fact-checked. This skill does not check facts.
- One sentence: what the viewer should understand or be able to do at the end.
- The format: a long (16:9, e.g. 1920x1080) or a Short (9:16, 1080x1920).
- The proof you are allowed to show: your own screenshots, recordings, numbers from your own receipts, or licensed clips with their licence noted.
- On the first run, use a made-up script. Clean real material locally first: remove client names, phone numbers, account IDs and anything you would not show on screen.

## What you get back

One folder with four files:

1. `STYLE.md`: the locked look for this video (the colour-by-meaning table, type sizes, pacing, the logo and face rules).
2. `SCENES.md`: one row per scene with time span, narration, what is on screen, the motion verb, on-screen text and proof asset.
3. `briefs/chapter-<n>.md`: one build brief per chapter, ready to hand to a sub-agent or a person.
4. `REVIEW.md`: the gates and the review prompt for a reviewer who did not build it.

## Steps

1. **Lock the look before any scene.** Write `STYLE.md` once and never let a builder change it.
   - **Colour means something.** Pick a base colour and give every other colour one job. Example (dark chalkboard look): white for plain text, orange for the keyword of the line, slate blue for a tool or the AI, brick red for a problem, mint for a pass. Never colour for decoration.
   - **Readable sizes.** In a 16:9 long, any active text is at least 5% of frame height (about 54 px at 1080). In a 9:16 Short, active text is at least 60 px tall on the 1080x1920 frame. Small source labels are the only exception.
   - **Logos and faces.** Real tool logos only from the brand's own assets or as simple drawn tiles that follow its brand rules. Never AI-generated logos, and never AI-generated faces of real people.
2. **Pace it.** The screen changes every 2–4 seconds in a long and every 1.5–2.5 seconds in a Short. A chapter card stays up 2 seconds at most and is never a silent card right after the opening promise. The only exception is the long-video ending hold in step 5.
3. **Write `SCENES.md` from the script, line by line.** For each scene: start and end time (from the voice once it exists, estimated until then), the narration it covers, what is on screen, one motion verb (draw, reveal, pin, count up, cross out, zoom to), the on-screen text and the proof asset.
   - **Show one thing at a time.** A table or list reveals one group at a time with the rest dimmed.
   - **Proof goes big.** A screenshot or clip fills at least 60% of the frame width, cropped to the part that matters, with a small source and date label.
   - **Every number on screen has a source** in your receipts or a linked page. Anything without one becomes a plain sentence or comes out.
4. **Shorts rules,** if the format is 9:16:
   - Frame 1 shows a number or a visible result, not a logo or a title.
   - Nothing important in the bottom 350 px or the right 150 px, where the platform's buttons sit.
   - Captions sit in one band in the lower middle.
   - No end card. The last frame loops cleanly back to frame 1.
5. **Long-video ending:** hold the final frame at least 10 seconds with empty space for end-screen elements.
6. **Split into chapter briefs.** One builder per chapter, one at a time on a small machine. Each `briefs/chapter-<n>.md` has:
   - `STYLE.md` (unchanged);
   - its rows from `SCENES.md`;
   - the exact narration with timings;
   - the asset folder it may read;
   - the one folder it may write;
   - the gate it must pass before saying done (step 7).
   - Builders write code only to their own folder and never change the style or another chapter.
7. **Gates per chapter, before stitching:**
   - the tool's own lint and check report 0 errors;
   - captions match the voice word for word, with no overlapping cues;
   - a contact sheet with one still every 2 seconds, which the builder reads and fixes;
   - before a render, enough free memory and disk, and renders run one at a time.
8. **Independent review.** A different model, or a fresh session with no build history, gets the rendered video, the sound measurement report, the contact sheets, the captions, the script, `STYLE.md`, `SCENES.md` and the proof sources behind every on-screen number, never the builder's chat. Narration timing, motion and audio can only be judged from the rendered video and the measurements. If the reviewer cannot play or measure them, those checks are marked UNVERIFIED, not passed. It returns PASS, PASS WITH FIXES (exact fixes) or FAIL. The builder applies the fixes using the reviewer's wording, then the changed parts are reviewed again. Stop after 3 rounds and take what is left to a person.
9. **Sound by measurement** when nobody listens to the mix:
   - while someone is speaking, sound effects sit at least 12 dB below the voice, measured as RMS on the separate voice and effects tracks in 1-second windows;
   - master around −14 LUFS integrated with true peak at −1.5 dBTP or lower, measured with a loudness meter such as ffmpeg's `ebur128` filter;
   - any number you could not measure goes in the receipt as UNVERIFIED, never as a pass.

## The review prompt (goes in REVIEW.md)

```text
You review a finished explainer video build. You did not build it. Read only the files given.
Check against STYLE.md and SCENES.md:
1. Does every scene match its row (narration span, visual, on-screen text)?
2. Any text below the size rule, or a crowded frame showing more than one group?
3. Any number on screen without a source in the receipts?
4. Do the captions match the narration word for word?
5. For a Short: is frame 1 a number or a result, and is the bottom and right safe zone clear?
6. Any AI-generated logo or real face, or any private detail on screen?
7. Watching the rendered video and reading the sound report: does the narration line up with each scene, does the motion read cleanly, and does the audio meet the sound rules? If you cannot play or measure it, write UNVERIFIED for that check.
Return: VERDICT: PASS | PASS WITH FIXES | FAIL, then numbered findings with timestamps and the exact fix.
```

## 5-minute test

Run the skill on the made-up script in `tests/packs/motion-explainer/input.md` of the repo. A pass means:

- the output has the four files;
- every scene row has a time span, a motion verb and a proof note;
- the brief refuses the traps in the script (an AI-generated logo, a ranking claim with no source, a Short that opens on a title card).

## Human approval

This skill only writes briefs and checklists. Rendering is your build tool's job. Uploading, scheduling and publishing the video stay with a person, after the independent review has passed. Never post or upload from this skill.

## Next job

Hand the chapter briefs to your builder. After the review passes, a person decides whether the video goes out.
