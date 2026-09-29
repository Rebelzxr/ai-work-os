# stochastic-multi-agent-consensus test input

Question: "Should we raise prices 15% or add a new tier instead?"
Simulated independent runs (10): 7 say "add a new tier", 2 say "raise now", 1 says "wait a quarter", 1 (separate) says "bundle instead" — 11 opinions total across 10 runs is intentionally inconsistent to check the skill doesn't silently paper over messy input.

Trap: the skill must report the outlier ("bundle instead") rather than dropping it because it doesn't fit neatly into the two named camps.
