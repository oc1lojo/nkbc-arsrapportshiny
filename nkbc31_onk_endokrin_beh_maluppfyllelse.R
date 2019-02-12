GLOBALS <- defGlobals(
  LAB = "Endokrin behandling, måluppfyllelse",
  POP = "opererade östrogenreceptorpositiva invasiva fall utan fjärrmetastaser vid diagnos.",
  SHORTPOP = "opererade ER+ invasiva fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "d_onk_sjhkod",
  TARGET = c(85, 90)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Går på det som finns, pre eller postop. Om det ena saknas antas samma som finns för det andra.
    outcome = as.logical(pmax(post_endo_Värde, pre_endo_Värde, na.rm = TRUE))
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,

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
  folder = "nkbc31",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      paste(
        "Endokrin behandling bör erbjudas till alla patienter med östrogenreceptorpositiv (ER+) bröstcancer.",
        "För patienter med mycket låg risk för återfall (tumör <=10 mm av luminal A-typ utan spridning till lymfkörtlarna) kan man avstå från endokrin behandling förutsatt att patienten är informerad om balansen mellan risk och nytta.",
        "I de fall där samsjuklighet föreligger får nyttan med endokrin behandling avvägas med hänsyn till övriga medicinska faktorer."
      ),
      descTarg(),
      sep = str_sep_description
    ),
    paste(
      "Både preoperativ och postoperativ endokrin behandling är medtaget i beräkningen.",
      paste(
        "Här presenteras data för påbörjad behandling.",
        "Det finns studier som visar att ca 70% av patienterna stoppar eller gör längre avbrott i sin endokrinabehandling i huvudsak p.g.a. biverkningar."
      ),
      onkRed,
      descTolk,
      sep = str_sep_description
    ),
    paste(
      descTekBes(),
      sep = str_sep_description
    )
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)
