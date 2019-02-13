dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc40_def$sjhkod_var) %>%
  mutate(
    # Prim op eller preop onk beh
    outcome = factor(d_prim_beh_Värde,
      levels = c(1, 2),
      labels = c(
        "Primär operation",
        "Preoperativ onkologisk behandling"
      )
    )
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_nstad, d_subtyp)

rccShiny(
  data = dftemp,
  folder = nkbc40_def$code,
  path = output_path,
  outcomeTitle = nkbc40_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc40_def),
  description = compile_description(nkbc40_def, report_end_year),
  varOther = compile_varOther(nkbc40_def),
  targetValues = nkbc40_def$target_values
)
