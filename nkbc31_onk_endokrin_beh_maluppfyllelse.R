dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc31_def$sjhkod_var) %>%
  mutate(
    # Går på det som finns, pre eller postop. Om det ena saknas antas samma som finns för det andra.
    outcome = as.logical(pmax(post_endo_Värde, pre_endo_Värde, na.rm = TRUE))
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # ER+
    d_er_Värde == 1,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc31_def$code,
  path = output_path,
  outcomeTitle = nkbc31_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc31_def),
  description = compile_description(nkbc31_def, report_end_year),
  varOther = compile_varOther(nkbc31_def),
  targetValues = nkbc31_def$target_values
)
