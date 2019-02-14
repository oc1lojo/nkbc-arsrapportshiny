dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc01)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc01_pop() %>%
  mutate_nkbc01_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc01))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc01),
  path = output_path,
  outcomeTitle = lab(nkbc01),
  textBeforeSubtitle = textBeforeSubtitle(nkbc01),
  description = description(nkbc01, report_end_year),
  varOther = varOther(nkbc01),
  targetValues = target_values(nkbc01)
)
