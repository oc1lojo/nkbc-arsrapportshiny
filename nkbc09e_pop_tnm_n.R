df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc09e)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09e_pop() %>%
  mutate_nkbc09e_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc09e))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc09e),
  path = output_path,
  outcomeTitle = lab(nkbc09e),
  textBeforeSubtitle = textBeforeSubtitle(nkbc09e),
  description = description(nkbc09e, report_end_year),
  varOther = varOther(nkbc09e),
  targetValues = target_values(nkbc09e)
)
