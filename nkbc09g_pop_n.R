NAME <- "nkbc09g2"
df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc09g)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09g_pop() %>%
  mutate_nkbc09g_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc09g))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc09g),
  path = output_path,
  outcomeTitle = lab(nkbc09g),
  textBeforeSubtitle = textBeforeSubtitle(nkbc09g),
  description = description(nkbc09g, report_end_year),
  varOther = varOther(nkbc09g),
  targetValues = target_values(nkbc09g)
)
