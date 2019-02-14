dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc09a)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09a_pop() %>%
  mutate_nkbc09a_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc09a))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc09a),
  path = output_path,
  outcomeTitle = lab(nkbc09a),
  textBeforeSubtitle = textBeforeSubtitle(nkbc09a),
  description = description(nkbc09a, report_end_year),
  varOther = varOther(nkbc09a),
  targetValues = target_values(nkbc09a)
)
