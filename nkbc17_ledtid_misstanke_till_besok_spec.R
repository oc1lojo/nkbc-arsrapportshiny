df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc17)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc17_pop() %>%
  mutate_nkbc17_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc17))
  )
rccShiny(
  data = df_tmp,
  folder = code(nkbc17),
  path = output_path,
  outcomeTitle = lab(nkbc17),
  textBeforeSubtitle = textBeforeSubtitle(nkbc17),
  description = description(nkbc17, report_end_year),
  varOther = varOther(nkbc17),
  propWithinValue = prop_within_value(nkbc17),
  targetValues = target_values(nkbc17)
)
