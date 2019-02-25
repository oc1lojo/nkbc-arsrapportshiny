df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc15)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc15_pop() %>%
  mutate_nkbc15_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc15))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc15),
  path = output_path,
  outcomeTitle = lab(nkbc15),
  textBeforeSubtitle = textBeforeSubtitle(nkbc15),
  description = description(nkbc15, report_end_year),
  varOther = varOther(nkbc15),
  propWithinValue = prop_within_value(nkbc15),
  targetValues = target_values(nkbc15)
)
