dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc03)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc03_pop() %>%
  mutate_nkbc03_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc03))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc03),
  path = output_path,
  outcomeTitle = lab(nkbc03),
  textBeforeSubtitle = textBeforeSubtitle(nkbc03),
  description = description(nkbc03, report_end_year),
  varOther = varOther(nkbc03),
  targetValues = target_values(nkbc03)
)
