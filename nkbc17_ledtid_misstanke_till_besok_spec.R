dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc17)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc17_pop() %>%
  mutate_nkbc17_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc17))
  )
rccShiny(
  data = dftemp,
  folder = code(nkbc17),
  path = output_path,
  outcomeTitle = lab(nkbc17),
  textBeforeSubtitle = textBeforeSubtitle(nkbc17),
  description = description(nkbc17, report_end_year),
  varOther = varOther(nkbc17),
  propWithinValue = nkbc17$prop_within_value,
  targetValues = target_values(nkbc17)
)
