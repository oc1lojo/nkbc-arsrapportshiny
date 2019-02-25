df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc10)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc10_pop() %>%
  mutate_nkbc10_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc10))
  )
rccShiny(
  data = df_tmp,
  folder = code(nkbc10),
  path = output_path,
  outcomeTitle = lab(nkbc10),
  textBeforeSubtitle = textBeforeSubtitle(nkbc10),
  description = description(nkbc10, report_end_year),
  varOther = varOther(nkbc10),
  targetValues = target_values(nkbc10)
)
