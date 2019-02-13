dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09d_def$sjhkod_var) %>%
  mutate(
    outcome = d_subtyp
  ) %>%
  filter(
    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc09d_def$code,
  path = output_path,
  outcomeTitle = nkbc09d_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09d_def),
  description = compile_description(nkbc09d_def, report_end_year),
  varOther = compile_varOther(nkbc09d_def),
  targetValues = nkbc09d_def$target_values
)
