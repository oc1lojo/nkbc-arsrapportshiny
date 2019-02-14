df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc11)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc11_pop() %>%
  mutate_nkbc11_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc11))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc11),
  path = output_path,
  outcomeTitle = lab(nkbc11),
  textBeforeSubtitle = textBeforeSubtitle(nkbc11),
  description = description(nkbc11, report_end_year),
  varOther = varOther(nkbc11),
  targetValues = target_values(nkbc11)
)
