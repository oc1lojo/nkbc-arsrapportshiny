dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc01_def$sjhkod_var) %>%
  mutate(
    a_pat_alder = as.numeric(a_pat_alder),

    # Hantera missing
    outcome = as.logical(ifelse(a_diag_screening_Värde %in% c(0, 1), a_diag_screening_Värde, NA))
  ) %>%
  filter(
    # Ålder 40-74 år vid diagnos
    a_pat_alder <= 74,
    a_pat_alder >= 40,

    # Enbart kvinnor
    KON_VALUE == 2,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc01_def$code,
  path = output_path,
  outcomeTitle = nkbc01_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc01_def),
  description = compile_description(nkbc01_def, report_end_year),
  varOther = compile_varOther(nkbc01_def),
  targetValues = nkbc01_def$target_values
)
