dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc26)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc26_pop() %>%
  mutate_nkbc26_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc26))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc26),
  path = output_path,
  outcomeTitle = lab(nkbc26),
  textBeforeSubtitle = textBeforeSubtitle(nkbc26),
  description = description(nkbc26, report_end_year),
  varOther = varOther(nkbc26),
  targetValues = target_values(nkbc26)
)
