nkbc41_def <- list(
  code = "nkbc41",
  lab = "Endokrin behandling, pre- respektive postoperativt",
  pop = "opererade östrogenreceptorpositiva invasiva fall utan fjärrmetastaser vid diagnos",
  pop_short = "opererade ER+ invasiva fall utan fjärrmetastaser vid diagnos",
  sjhkod_var = "d_onk_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Den aktuella tabellen presenterar andelen fall som fått preoperativ respektive postoperativ endokrin behandling eller bägge.",
  vid_tolkning = "Här presenteras data för påbörjad behandling. Det finns studier som visar att ca 70% av patienterna stoppar eller gör längre avbrott i sin endokrinabehandling i huvudsak p.g.a. biverkningar.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc41_def$sjhkod_var) %>%
  mutate(
    # Pre eller postoperativ
    outcome = factor(
      case_when(
        post_endo_Värde == 1 & pre_endo_Värde == 1 ~ 1,
        pre_endo_Värde == 1 ~ 0,
        post_endo_Värde == 1 ~ 2,
        post_endo_Värde == 0 | pre_endo_Värde == 0 ~ 3
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

    # ER+
    d_er_Värde == 1,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc41_def$code,
  path = output_path,
  outcomeTitle = nkbc41_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc41_def),
  description = compile_description(nkbc41_def, report_end_year),
  varOther = compile_varOther(nkbc41_def),
  targetValues = nkbc41_def$target_values
)
