dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc26_def$sjhkod_var) %>%
  mutate(
    outcome = case_when(
      op_kir_axilltyp_Värde == 1 ~ 1L,
      op_kir_axilltyp_Värde == 2 ~ 0L,
      op_kir_axilltyp_Värde == 3 ~ 1L,
      op_kir_axilltyp_Värde == 4 ~ 0L,
      op_kir_axilltyp_Värde == 98 ~ NA_integer_,
      TRUE ~ NA_integer_
    ),
    outcome = as.logical(ifelse(op_kir_axill_Värde %in% 0, 0, outcome))
  ) %>%
  filter(
    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # Klinisk N0
    a_tnm_nklass_Värde == 0,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc26_def$code,
  path = output_path,
  outcomeTitle = nkbc26_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc26_def),
  description = compile_description(nkbc26_def, report_end_year),
  varOther = compile_varOther(nkbc26_def),
  targetValues = nkbc26_def$target_values
)
