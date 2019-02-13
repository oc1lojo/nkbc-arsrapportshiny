dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc06_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_diag_preopmorf_Värde %in% c(0, 1), a_diag_preopmorf_Värde, NA))
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc06_def$code,
  path = output_path,
  outcomeTitle = nkbc06_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc06_def),
  description = compile_description(nkbc06_def, report_end_year),
  varOther = compile_varOther(nkbc06_def),
  targetValues = nkbc06_def$target_values
)
