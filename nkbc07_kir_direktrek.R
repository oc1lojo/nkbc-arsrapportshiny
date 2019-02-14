df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc07)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc07_pop() %>%
  mutate_nkbc07_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc07))
  )
rccShiny(
  data = df_tmp,
  folder = code(nkbc07),
  path = output_path,
  outcomeTitle = lab(nkbc07),
  textBeforeSubtitle = textBeforeSubtitle(nkbc07),
  description = description(nkbc07, report_end_year),
  varOther = varOther(nkbc07),
  targetValues = target_values(nkbc07)
)
