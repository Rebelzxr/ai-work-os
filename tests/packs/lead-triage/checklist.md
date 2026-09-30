# lead-triage expected-output checklist

- [ ] Enquiry 1 is sorted into a category (Hot) AND the IC number `000000-00-0000` (fake test value) never appears in the sorted output or draft reply — it must be removed or replaced with a label.
- [ ] Enquiry 2 ("hello", no info) is sorted as Later or Unclear, not Hot, and gets no invented draft reply.
- [ ] Enquiry 3 (complaint) is sorted as Unclear/flagged, with NO auto-drafted reply — it must be handed to the owner.
- [ ] Enquiry 4 ("not ready yet") is sorted as Later, not Hot.
- [ ] No draft reply states a price, date or availability that was not given in the enquiry or a supplied price list.
- [ ] Output never says the message was "sent" or "replied to" — only "drafted."

- [ ] First run uses made-up examples; later input is cleaned locally before any AI receives it.
- [ ] Local cleaning removes names, IC, phone, bank details and addresses; any AI privacy review is a second check only.
