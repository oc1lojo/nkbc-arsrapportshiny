nkbc31_def <- list(
  code = "nkbc31",
  lab = "Endokrin behandling, måluppfyllelse",
  pop = "opererade östrogenreceptorpositiva invasiva fall utan fjärrmetastaser vid diagnos",
  pop_short = "opererade ER+ invasiva fall utan fjärrmetastaser vid diagnos",
  target_values = c(85, 90),
  sjhkod_var = "d_onk_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn =
    paste(
      "Endokrin behandling bör erbjudas till alla patienter med östrogenreceptorpositiv (ER+) bröstcancer.",
      "För patienter med mycket låg risk för återfall (tumör <=10 mm av luminal A-typ utan spridning till lymfkörtlarna) kan man avstå från endokrin behandling förutsatt att patienten är informerad om balansen mellan risk och nytta.",
      "I de fall där samsjuklighet föreligger får nyttan med endokrin behandling avvägas med hänsyn till övriga medicinska faktorer."
    ),
  vid_tolkning =
    c(
      "Både preoperativ och postoperativ endokrin behandling är medtaget i beräkningen.",
      paste(
        "Här presenteras data för påbörjad behandling.",
        "Det finns studier som visar att ca 70% av patienterna stoppar eller gör längre avbrott i sin endokrinabehandling i huvudsak p.g.a. biverkningar."
      )
    ),
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

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
