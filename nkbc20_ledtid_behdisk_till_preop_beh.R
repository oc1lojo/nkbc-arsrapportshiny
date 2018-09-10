NAME <- "nkbc20"

GLOBALS <- defGlobals(
  LAB = "Första behandlingsdiskussion till preoperativ onkologisk behandling",
  POP = "opererade fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling.",
  SJHKODUSE = "pre_inr_sjhkod",
  TARGET = c(75, 90)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    d_pre_onk_dat = pmin(as.Date(pre_kemo_dat),
      as.Date(pre_rt_dat),
      as.Date(pre_endo_dat),
      na.rm = TRUE
    ),

    outcome = as.numeric(ymd(d_pre_onk_dat) - ymd(a_planbeh_infopatdat)),
    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast preop onk behandling (planerad om utförd ej finns)
    prim_beh == 2,

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
      "I preoperativ onkologisk behandling ingår cytostatika, strålning eller endokrin behandling.
      <p></p>
      Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
      descTarg()
    ),
    paste0(
      "Andelen preoperativt behandlade patienter varierar i landet och före start av behandling görs flera undersökningar som kan förlänga tiden till start. Många patienter som startar preoperativ onkologisk behandling ingår i behandlingsstudier där vissa undersökningar är obligatoriska som annars hade gjorts senare. Siffrorna skall därför tolkas med viss försiktighet.
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
  propWithinValue = 14,
  targetValues = GLOBALS$TARGET
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
