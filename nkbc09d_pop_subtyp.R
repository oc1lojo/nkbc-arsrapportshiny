dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc09d)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09d_pop() %>%
  mutate_nkbc09d_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc09d))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc09d),
  path = output_path,
  outcomeTitle = lab(nkbc09d),
  textBeforeSubtitle = textBeforeSubtitle(nkbc09d),
  description = description(nkbc09d, report_end_year),
  varOther = varOther(nkbc09d),
  targetValues = target_values(nkbc09d)
)
