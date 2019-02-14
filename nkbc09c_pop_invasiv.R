dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc09c)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09c_pop() %>%
  mutate_nkbc09c_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc09c))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc09c),
  path = output_path,
  outcomeTitle = lab(nkbc09c),
  textBeforeSubtitle = textBeforeSubtitle(nkbc09c),
  description = description(nkbc09c, report_end_year),
  varOther = varOther(nkbc09c),
  targetValues = target_values(nkbc09c)
)
