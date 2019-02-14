df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc19)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc19_pop() %>%
  mutate_nkbc19_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc19))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc19),
  path = output_path,
  outcomeTitle = lab(nkbc19),
  textBeforeSubtitle = textBeforeSubtitle(nkbc19),
  description = description(nkbc19, report_end_year),
  varOther = varOther(nkbc19),
  propWithinValue = prop_within_value(nkbc19),
  targetValues = target_values(nkbc19)
)
