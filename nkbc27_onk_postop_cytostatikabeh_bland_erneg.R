dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc27_def$sjhkod_var) %>%
  mutate(
    outcome = as.logical(post_kemo_Värde)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast primär opereration (planerad om utfärd ej finns)
    # (pga att info om tumörstorlek och spridning till N behövs)
    d_prim_beh_Värde == 1,

    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # ER-
    d_er_Värde == 2,

    # Tumörstorlek > 10 mm eller spridning till lymfkörtlar
    (op_pad_invstl > 10 | op_pad_lglmetant > 0),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc27_def$code,
  path = output_path,
  outcomeTitle = nkbc27_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc27_def),
  description = compile_description(nkbc27_def, report_end_year),
  varOther = compile_varOther(nkbc27_def),
  targetValues = nkbc27_def$target_values
)
