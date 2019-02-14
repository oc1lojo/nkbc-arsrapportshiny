df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc09b)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09b_pop() %>%
  mutate_nkbc09b_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc09b))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc09b),
  path = output_path,
  outcomeTitle = lab(nkbc09b),
  textBeforeSubtitle = textBeforeSubtitle(nkbc09b),
  description = description(nkbc09b, report_end_year),
  varOther = varOther(nkbc09b),
  propWithinUnit = nkbc09b$prop_within_unit,
  propWithinValue = nkbc09b$prop_within_value,
  targetValues = target_values(nkbc09b)
)
