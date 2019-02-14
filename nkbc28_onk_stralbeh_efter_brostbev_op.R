df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc28)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc28_pop() %>%
  mutate_nkbc28_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc28))
  )


rccShiny(
  data = df_tmp,
  folder = code(nkbc28),
  path = output_path,
  outcomeTitle = lab(nkbc28),
  textBeforeSubtitle = textBeforeSubtitle(nkbc28),
  description = description(nkbc28, report_end_year),
  varOther = varOther(nkbc28),
  targetValues = target_values(nkbc28)
)
