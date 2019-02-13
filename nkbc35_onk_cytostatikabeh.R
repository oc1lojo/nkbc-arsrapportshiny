dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc35_def$sjhkod_var) %>%
  mutate(
    # Pre eller postoperativ
    outcome = factor(
      case_when(
        post_kemo_Värde == 1 & pre_kemo_Värde == 1 ~ 1,
        pre_kemo_Värde == 1 ~ 0,
        post_kemo_Värde == 1 ~ 2,
        post_kemo_Värde == 0 | pre_kemo_Värde == 0 ~ 3
      ),
      levels = c(0, 1, 2, 3),
      labels = c(
        "Enbart preoperativ",
        "Både pre-och postoperativ",
        "Enbart postoperativ",
        "Ingen"
      )
    )
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

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome, a_pat_alder,
    d_er, d_tstad, d_nstad
  )

rccShiny(
  data = dftemp,
  folder = nkbc35_def$code,
  path = output_path,
  outcomeTitle = nkbc35_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc35_def),
  description = compile_description(nkbc35_def, report_end_year),
  varOther = compile_varOther(nkbc35_def),
  targetValues = nkbc35_def$target_values
)
