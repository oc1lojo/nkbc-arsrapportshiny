NAME <- "nkbc19"

GLOBALS <- defGlobals(
  LAB = "Första behandlingsdiskussion till operation",
  POP = "primärt opererade fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "op_inr_sjhkod",
  TARGET = c(75, 90)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = as.numeric(ymd(op_kir_dat) - ymd(a_planbeh_infopatdat)),

    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

    # Endast primär opereration (planerad om utförd ej finns)
    prim_op == 1,

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
      "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
      descTarg()
    ),
    descTolk,
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
  propWithinValue = 14,
  targetValues = GLOBALS$TARGET
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
