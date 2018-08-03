NAME <- "nkbc32"

# Antikroppsbehandling bland cytostatikabehandlade ------------------------------------------------

GLOBALS <- defGlobals(
  LAB = "Antikroppsbehandling bland cytostatikabehandlade",
  POP = "opererade, cytostatikabehandlade HER2 positiva invasiva fall utan fjärrmetastaser vid diagnos.",
  SHORTPOP = "opererade, cytostatikabehandlade HER2+ invasiva fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE <- "d_onk_sjhkod",
  TARGET = c(90, 95)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Går på det som finns, pre eller postop. Om det ena saknas antas samma som finns för det andra.
    outcome = as.logical(pmax(post_antikropp_Värde, pre_antikropp_Värde, na.rm = TRUE)),

    d_kemo = as.logical(pmax(post_kemo_Värde, pre_kemo_Värde, na.rm = TRUE))
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

    # Endast cytostatikabehandlade
    d_kemo == TRUE,

    # HER2+ (amplifiering eller 3+).
    her2 == 1,

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
      "Vid HER2-positiv invasiv bröstcancer rekommenderas behandling med antikroppsbehandling i kombination efter eller med cytostatika, under förutsättning att patienten kan tolerera det sistnämnda.",
      descTarg()
    ),
    paste0(
      "Både preoperativ och postoperativ antikropps- och cytostatikabehandling är medtaget i beräkningen.
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
