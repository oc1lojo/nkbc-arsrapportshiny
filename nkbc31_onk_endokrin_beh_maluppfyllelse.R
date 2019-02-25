df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc31)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc31_pop() %>%
  mutate_nkbc31_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc31))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc31),
  path = output_path,
  outcomeTitle = lab(nkbc31),
  textBeforeSubtitle = textBeforeSubtitle(nkbc31),
  description = description(nkbc31, report_end_year),
  varOther = varOther(nkbc31),
  targetValues = target_values(nkbc31)
)
