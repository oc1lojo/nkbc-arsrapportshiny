df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc04)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc04_pop() %>%
  mutate_nkbc04_outcome() %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc04))
  )
rccShiny(
  data = df_tmp,
  folder = code(nkbc04),
  path = output_path,
  outcomeTitle = lab(nkbc04),
  textBeforeSubtitle = textBeforeSubtitle(nkbc04),
  description = description(nkbc04, report_end_year),
  varOther = varOther(nkbc04),
  targetValues = target_values(nkbc04)
)
