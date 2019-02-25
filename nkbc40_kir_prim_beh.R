df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc40)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc40_pop() %>%
  mutate_nkbc40_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc40))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc40),
  path = output_path,
  outcomeTitle = lab(nkbc40),
  textBeforeSubtitle = textBeforeSubtitle(nkbc40),
  description = description(nkbc40, report_end_year),
  varOther = varOther(nkbc40),
  targetValues = target_values(nkbc40)
)
