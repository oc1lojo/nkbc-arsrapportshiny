df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc42)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc42_pop() %>%
  mutate_nkbc42_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc42))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc42),
  path = output_path,
  outcomeTitle = lab(nkbc42),
  textBeforeSubtitle = textBeforeSubtitle(nkbc42),
  description = description(nkbc42, report_end_year),
  varOther = varOther(nkbc42),
  targetValues = target_values(nkbc42)
)
