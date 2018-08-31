NAME <- "nkbc06"

GLOBALS <- defGlobals(
  LAB = "Fastställd diagnos innan operation",
  POP = "opererade fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "a_inr_sjhkod",
  TARGET = c(80, 90)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_diag_preopmorf_Värde %in% c(0, 1), a_diag_preopmorf_Värde, NA))
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

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
      "En fastställd diagnos innan behandlingsstart är viktigt för planering och genomförande av behandling och undvikande av omoperationer.",
      descTarg()
    ),
    paste0(
      "Det kan ibland vara nödvändigt att operera patienten innan diagnosen är fastställd för att undvika alltför långa utredningstider. Fastställd diagnos måste vägas mot tidsåtgång.
      <p></p>",
      descTolk
    ),
    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    ),
    list(
      var = "invasiv",
      label = c("Invasivitet vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
