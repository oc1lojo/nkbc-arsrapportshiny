df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc05)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc05_pop() %>%
  mutate_nkbc05_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc05))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc05),
  path = output_path,
  outcomeTitle = lab(nkbc05),
  textBeforeSubtitle = textBeforeSubtitle(nkbc05),
  description = description(nkbc05, report_end_year),
  varOther = varOther(nkbc05),
  targetValues = target_values(nkbc05)
)
