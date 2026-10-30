---
name: demo-video-edit
description: "Edit a raw talking-head or screen recording into a tight cut: remove restarts, false starts and long silences using word timestamps, add a zoom on a spoken cue word, one sound effect per new idea and a few animated cards for the main points, then decode-check the file and report the raw and cut lengths. Learns from timestamped notes by saving each one as a dated rule in this file. Use when someone has a raw recording and wants it edited. Edits local files only. Never uploads or publishes."
---

# Demo video edit

An editing style, written down. Give it a raw recording and it hands back a cut that follows the rules below. Every note you give with a timestamp becomes a new general rule at the bottom of this file the same day, so the next edit already follows it. The rule is written in general words only. Names, file names and anything from the recording stay in that cut's own `EDIT.md`.

This skill edits an existing recording. For a 30–60 second script and shot list before anything is filmed, run `video-brief` from this pack. For a full explainer built as motion graphics from a finished script, run `motion-explainer` from `aiwos-factory`. This skill only borrows small animated cards; it does not build explainer scenes.

## What to give it

- The raw recording (for example `video/raw-hook.mov`). It stays untouched; every output is a new file.
- The cue words you agreed before recording, if any: the word that means "zoom here", and the words that name each main point.
- How many cards you want and what each one says, or let it pick the main points from the transcript and show you the list first.
- The format: 16:9 (for example 1920x1080) or 9:16 (1080x1920).
- On the first run, use a made-up recording: a minute of you talking about anything, with a few real stumbles. Clean locally first: before any frame, transcript or audio goes into an AI tool, blur or cut client names, IC numbers, phone numbers, bank details, addresses and anything else on screen you would not show the public, and cut or mute any of it that is said out loud. Do a second check on the final render yourself, on your own machine, frame by frame where text is on screen, before anyone else sees the cut.

## Tools it uses

All free. Check each one runs before the first edit and say which are missing.

- **FFmpeg** and **ffprobe** for cutting, zooms, mixing sound, the decode check and measuring lengths.
- **Whisper** (any local build with word timestamps, such as faster-whisper) for the transcript. Use the word timestamps Whisper produces itself. Forced alignment can be sharper, but it can scramble the times on repeated phrases, which is exactly what restarts are; if you use it, re-check every cut by ear.
- **HyperFrames** or any HTML-to-video tool for the animated cards (optional). Without one, render each card as a still image and slide it in with FFmpeg's overlay.
- **Sound effects** you made yourself (a short synthesised whoosh, click or pop) or from a free library whose licence allows reuse. Write the source and licence of every sound in a `LICENSES.md` next to the cut.

## What you get back

In a new folder next to the raw file:

1. `cut.mp4`: the finished edit.
2. `transcript.txt`: the cut's transcript at output timecodes (`M:SS text`), so you can read what each second says.
3. `EDIT.md`: what was removed and why, each zoom and card with its time, each sound effect with its time and source, the raw and cut lengths, the check results, and anything left unverified. It also holds the **segment table**: one row for every kept piece of the raw, with its raw start and end and its output start and end in seconds to two decimals, after the padding and the shortened silences. Step 4 and step 5 fill it in. It is how a note's time on the cut is mapped back to the raw.
4. `LICENSES.md`: one line per sound or music file with its source and licence.

## Steps

1. **Measure the raw.** Read its length, frame size, frame rate and audio with ffprobe. Write the raw length in `EDIT.md` now, so the report at the end uses a measured number.
2. **Transcribe with word timestamps.** Keep one line per word with start and end time. Whisper sometimes mishears the first word of a file; add a second of silence at the front before transcribing and remove it from the times after.
3. **Choose what stays, by meaning.**
   - **Restarts and false starts:** when a line is said more than once, keep the last complete take, not the fragments before it. Check the kept take is a whole sentence; if it starts mid-clause, keep the fragment that supplies its start.
   - **Repeats across the video:** read the whole transcript once and list the points in order. If the same point is made twice, even in different words, keep the stronger one.
   - **Filler and dead air:** cut "um", "uh" and throat-clears only where removing them leaves clean speech.
   - Write the list of kept and cut lines in `EDIT.md` before cutting anything.
4. **Cut on the gaps, never inside a word.** Put each cut in the silence between two words. Leave about 0.13 s before a kept word and about 0.18 s after it, so word endings are not clipped. On an edge where you trimmed mid-sentence, use a tight 0.04 s so the next glued word does not leak in. Join clips that were next to each other in the raw back into one clip: a hard cut should only land where something was actually removed. Write each kept clip into the segment table in `EDIT.md` with the padding included.
5. **Tighten silences, keep breaths.** Inside the kept speech, shorten any pause longer than about 0.6 s down to about 0.3 s, cutting in the middle of the pause. Leave shorter pauses alone; they are the speaker's rhythm. Each shortened pause splits a row in the segment table, so update the raw and output times.
6. **Zoom on the cue word.** Find every "zoom" (or your agreed cue word) in the word timestamps. Start a smooth push-in to about 1.2x over about 0.3 s on that word, centred on the face or the part of the screen being talked about, hold it to the end of the sentence, then ease back. If the cue word was said only as an instruction, cut the word out and keep the zoom; if it is part of a real sentence, keep it.
7. **One sound effect per new idea.** Mark the start of each new point in the transcript. Place one short effect there, on the first word of the new point, not on every cut. Keep the voice at least 12 dB louder than the effects and any music, and duck music under speech. Check it by measuring: run FFmpeg's `ebur128` filter on the voice track and on the effects and music track over the same speech windows, and write both short-term loudness numbers in `EDIT.md`.
8. **Animated cards for the main points.** For each card:
   - one short line, the words you actually said or the point in fewer words, never a new claim;
   - it lands on the word that names the point, not before;
   - it stays up at least as long as it takes to read at 3 words a second, plus one second;
   - it never covers the speaker's face or the part of the screen being talked about.
9. **Look and pacing.**
   - **Readable text:** in 16:9, any text on screen is at least 5% of the frame height (about 54 px at 1080). In 9:16, at least 60 px tall on the 1080x1920 frame.
   - **Pacing:** in the hook, something changes on screen every 0.5–1 s (a cut, a zoom, a card). After the hook, shots can breathe for 1–2 s, and nothing on screen stays completely still for more than 4 s.
   - **Captions** (if you burn them in) sit in one band and never cover the hook: the first line, the face or the result shown in the first seconds. In 9:16, start by keeping anything important out of the bottom 350 px and the right 150 px, where most apps put their buttons. These are starting margins, not a rule for every app. Ask which app the video is for and check that app's current overlay template, because the buttons and the caption area differ by app and by caption length. If `video-brief` made caption rules for this video, follow them and run its caption checker.
   - **Loudness:** bring the final mix to about -14 LUFS with true peaks at -1 dBTP or lower. Measure the finished file (FFmpeg's `loudnorm` with `print_format=summary`, or `ebur128=peak=true`) and write the integrated loudness and true peak in `EDIT.md`.
10. **Render and check the file.**
    - Full decode check of every stream: `ffmpeg -v error -i cut.mp4 -map 0 -f null -` must exit with status 0 and print nothing. Check with ffprobe that the file has the video and audio streams you expect.
    - Measure the cut's length with ffprobe.
    - Make a contact sheet (one frame every 2 s) as a quick sampling check. It can miss anything on screen for less than 2 s, so it never proves the cut is clean on its own.
    - Watch the whole cut once at normal speed with the sound on.
    - Step frame by frame across the start and end of every cut, zoom, card and caption listed in `EDIT.md`, and do the frame-by-frame second check for private text. Every zoom, card and caption is where `EDIT.md` says, and no private text is in any frame.
    - Re-transcribe the finished cut and compare it with `transcript.txt`. A doubled word or a missing sentence means a cut is in the wrong place; fix it and render again.
    - Run FFmpeg's `freezedetect` (3 s) to catch long stills.
11. **Report.** Tell the user the raw length and the cut length (both as M:SS, from ffprobe), how much was removed, how many restarts, silences, zooms, sound effects and cards there are, and anything left unverified. Only measured numbers.
12. **Independent review before anything is uploaded.** A person who did not build it watches and listens to the whole cut. If you also want an AI review, it only ever gets the finished cut and its files after your own second check in step 10, never the raw recording. The same clean-locally-first rule applies, and if a service is not one you would trust with the cut, use a reviewer on your own machine or a person instead. They check for clipped words, doubled lines, cards at the wrong time, unreadable text, sound too loud against the voice and any private data on screen or in speech. Their verdict is PASS or REVISE. Fix every REVISE and review again. This skill does not upload; the person decides that after a PASS.

## When the user gives a timestamped note

1. Read the time off the cut the note is about, never an assumed time. Map it from the cut's timeline back to the raw using the segment table in `EDIT.md`.
2. Apply the fix, render again and rerun the checks in step 10.
3. Turn the note into a general rule, not only this fix ("cards come in on the word that names them", not "move card 2 by half a second").
4. Add it to **Rules learned** below as one dated line: `YYYY-MM-DD · what went wrong, in general words · the rule`. Never write a file name, a cut name, a person, a client or anything said or shown in the recording into this file, because the skill can be shared. The time, the cut name and the specific fix go in that cut's `EDIT.md`. If the rule conflicts with a rule already in this file, ask which one wins before saving.
5. Tell the user the rule you saved, word for word.

## Failure modes

- Do not cut inside a word or clip its ending; when unsure, keep a little extra.
- Do not keep a fragment that starts mid-sentence when the whole sentence exists in another take.
- Do not add a sound effect to every cut; one per new idea.
- Do not put words on a card that the speaker did not say or that the recording does not support.
- Do not report a length, count or check result you did not measure.
- Do not touch or overwrite the raw file.

## Rules learned

Newest last. One dated line per note, added the same day the note is given.

- (none yet)

## Human approval

**This skill edits local video files and writes a report. It never uploads, posts or publishes anything. The finished cut gets an independent review before upload (a person, or an AI reviewer only after your own local second check), and a person approves the final file before it is posted anywhere.**
