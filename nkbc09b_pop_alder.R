dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09b_def$sjhkod_var) %>%
  mutate(
    outcome = a_pat_alder
  ) %>%
  filter(
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc09b_def$code,
  path = output_path,
  outcomeTitle = nkbc09b_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09b_def),
  description = compile_description(nkbc09b_def, report_end_year),
  varOther = compile_varOther(nkbc09b_def),
  propWithinUnit = nkbc09b_def$prop_within_unit,
  propWithinValue = nkbc09b_def$prop_within_value,
  targetValues = nkbc09b_def$target_values
)
