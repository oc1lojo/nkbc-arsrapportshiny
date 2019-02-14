dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc10)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc10_pop() %>%
  mutate_nkbc10_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc10))
  )
rccShiny(
  data = dftemp,
  folder = code(nkbc10),
  path = output_path,
  outcomeTitle = lab(nkbc10),
  textBeforeSubtitle = textBeforeSubtitle(nkbc10),
  description = description(nkbc10, report_end_year),
  varOther = varOther(nkbc10),
  targetValues = target_values(nkbc10)
)
