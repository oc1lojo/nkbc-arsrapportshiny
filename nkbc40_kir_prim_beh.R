dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc40)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc40_pop() %>%
  mutate_nkbc40_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc40))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc40),
  path = output_path,
  outcomeTitle = lab(nkbc40),
  textBeforeSubtitle = textBeforeSubtitle(nkbc40),
  description = description(nkbc40, report_end_year),
  varOther = varOther(nkbc40),
  targetValues = target_values(nkbc40)
)
