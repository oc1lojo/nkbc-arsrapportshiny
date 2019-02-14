dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc35)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc35_pop() %>%
  mutate_nkbc35_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc35))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc35),
  path = output_path,
  outcomeTitle = lab(nkbc35),
  textBeforeSubtitle = textBeforeSubtitle(nkbc35),
  description = description(nkbc35, report_end_year),
  varOther = varOther(nkbc35),
  targetValues = target_values(nkbc35)
)
