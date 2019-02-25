df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc27)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc27_pop() %>%
  mutate_nkbc27_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc27))
  )
rccShiny(
  data = df_tmp,
  folder = code(nkbc27),
  path = output_path,
  outcomeTitle = lab(nkbc27),
  textBeforeSubtitle = textBeforeSubtitle(nkbc27),
  description = description(nkbc27, report_end_year),
  varOther = varOther(nkbc27),
  targetValues = target_values(nkbc27)
)
