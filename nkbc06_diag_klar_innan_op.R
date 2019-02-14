df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc06)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc06_pop() %>%
  mutate_nkbc06_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc06))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc06),
  path = output_path,
  outcomeTitle = lab(nkbc06),
  textBeforeSubtitle = textBeforeSubtitle(nkbc06),
  description = description(nkbc06, report_end_year),
  varOther = varOther(nkbc06),
  targetValues = target_values(nkbc06)
)
