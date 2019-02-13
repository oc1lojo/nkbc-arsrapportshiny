dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09e_def$sjhkod_var) %>%
  mutate(
    outcome = d_nstad
  ) %>%
  filter(
    # Endast invasiv cancer
    # invasiv == "Invasiv cancer", Bortselekterat pga om väljer enbart invasiv
    # cancer så tas alla med uppgift saknas på invasiv bort. Dock några fel? reg
    # in situ och N1 men men...

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc09e_def$code,
  path = output_path,
  outcomeTitle = nkbc09e_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09e_def),
  description = compile_description(nkbc09e_def, report_end_year),
  varOther = compile_varOther(nkbc09e_def),
  targetValues = nkbc09e_def$target_values
)
