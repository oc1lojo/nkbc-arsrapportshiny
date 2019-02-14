dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc08)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc08_pop() %>%
  mutate_nkbc08_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc08))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc08),
  path = output_path,
  outcomeTitle = lab(nkbc08),
  textBeforeSubtitle = textBeforeSubtitle(nkbc08),
  description = description(nkbc08, report_end_year),
  varOther = varOther(nkbc08),
  targetValues = target_values(nkbc08)
)
