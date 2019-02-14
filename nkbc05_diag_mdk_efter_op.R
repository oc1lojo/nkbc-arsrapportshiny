dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc05)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc05_pop() %>%
  mutate_nkbc05_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc05))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc05),
  path = output_path,
  outcomeTitle = lab(nkbc05),
  textBeforeSubtitle = textBeforeSubtitle(nkbc05),
  description = description(nkbc05, report_end_year),
  varOther = varOther(nkbc05),
  targetValues = target_values(nkbc05)
)
