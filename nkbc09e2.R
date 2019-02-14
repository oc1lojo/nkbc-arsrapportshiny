NAME <- "nkbc09e2"

GLOBALS <- defGlobals(
  LAB = "Spridning till lymfkörtlarna",
  POP = "opererade fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "op_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome =
      factor(
        case_when(
          op_pad_lglmetant == 0 ~ "Nej (pN-)",
          op_pad_lglmetant > 0 ~ "Ja (pN+)",
          TRUE ~ "Uppgift saknas"
        ),
        levels = c("Nej (pN-)", "Ja (pN+)", "Uppgift saknas")
      )
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
    paste(
      "Kännedom om tumörspridning till axillens lymfkörtlar ger vägledning för behandling och information om prognos.",
      "<mark>Tumörspridning till axillens lymfkörtlar fastställs genom cytologi eller kirurgi (analys av sentinel node och/eller övriga lymfkörtlar i axillen)</mark>."
    ),
    paste0(
      "<mark>I populationen ingår både primärt opererade och opererade efter påbörjad/genomförd preoperativ onkologisk behandling.</mark>",
      "<p></p>",
      "<mark>Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen.</mark>",
      "<p></p>",
      descTolk
    ),    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  )
)

cat(link, fill = TRUE)
# runApp(paste0("Output/apps/sv/", NAME))
