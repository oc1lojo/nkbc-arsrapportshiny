df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc02)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc02_pop() %>%
  mutate_nkbc02_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc02))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc02),
  path = output_path,
  outcomeTitle = lab(nkbc02),
  textBeforeSubtitle = textBeforeSubtitle(nkbc02),
  description = description(nkbc02, report_end_year),
  varOther = varOther(nkbc02),
  targetValues = target_values(nkbc02)
)
