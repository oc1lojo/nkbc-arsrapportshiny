dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc19)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc19_pop() %>%
  mutate_nkbc19_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc19))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc19),
  path = output_path,
  outcomeTitle = lab(nkbc19),
  textBeforeSubtitle = textBeforeSubtitle(nkbc19),
  description = description(nkbc19, report_end_year),
  varOther = varOther(nkbc19),
  propWithinValue = nkbc19$prop_within_value,
  targetValues = target_values(nkbc19)
)
