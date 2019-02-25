df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc09f)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09f_pop() %>%
  mutate_nkbc09f_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc09f))
  )
rccShiny(
  data = df_tmp,
  folder = code(nkbc09f),
  path = output_path,
  outcomeTitle = lab(nkbc09f),
  textBeforeSubtitle = textBeforeSubtitle(nkbc09f),
  description = description(nkbc09f, report_end_year),
  varOther = varOther(nkbc09f),
  targetValues = target_values(nkbc09f)
)
