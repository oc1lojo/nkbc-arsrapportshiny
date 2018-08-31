NAME <- "nkbc41"

GLOBALS <- defGlobals(
  LAB = "Endokrin behandling, fördelning",
  POP = "opererade östrogenreceptorpositiva invasiva fall utan fjärrmetastaser vid diagnos.",
  SHORTPOP = "opererade ER+ invasiva fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "d_onk_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
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
    period <= YEAR - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast invasiv cancer
    invasiv == "Invasiv cancer",

    # ER+
    er == 1,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv)

link <- rccShiny(
  data = dftemp,
  folder = NAME,
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste0(
      "Endokrinbehandling bör erbjudas till alla patienter med östrogenreceptorpositiv (ER+) bröstcancer. I de fall där samsjuklighet föreligger får nyttan med endokrin behandling avvägas med hänsyn till övriga medicinska faktorer.",
      descTarg()
    ),
    paste0(
      "Här presenteras data för påbörjad behandling. Det finns studier som visar att ca 70% av patienterna stoppar eller gör längre avbrott i sin endokrinabehandling i huvudsak pga biverkningar.
      <p></p>",
      onkRed,
      "<p></p>",
      descTolk
    ),
    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
