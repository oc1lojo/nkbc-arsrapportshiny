dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc04)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc04_pop() %>%
  mutate_nkbc04_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc04))
  )
rccShiny(
  data = dftemp,
  folder = code(nkbc04),
  path = output_path,
  outcomeTitle = lab(nkbc04),
  textBeforeSubtitle = textBeforeSubtitle(nkbc04),
  description = description(nkbc04, report_end_year),
  varOther = varOther(nkbc04),
  targetValues = target_values(nkbc04)
)
