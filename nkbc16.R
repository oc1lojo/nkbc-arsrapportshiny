NAME <- "nkbc16"

GLOBALS <- defGlobals(
  LAB = "Välgrundad misstanke om cancer till preoperativ onkologisk behandling",
  POP = "opererade fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling.",
  SJHKODUSE <- "pre_inr_sjhkod",
  TARGET = c(75, 90)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    d_a_diag_misscadat = ymd(coalesce(a_diag_misscadat, a_diag_kontdat)),
    d_pre_onk_dat = pmin(ymd(pre_kemo_dat),
      ymd(pre_rt_dat),
      ymd(pre_endo_dat),
      na.rm = TRUE
    ),

    outcome = as.numeric(ymd(d_pre_onk_dat) - d_a_diag_misscadat),

    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast fall med år från 2013 (1:a kontakt tillkom 2013)
    period >= 2013,

    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast preop onk behandling (planerad om utförd ej finns)
    prim_op == 2,

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
      "Startpunkten för SVF har tolkats olika av vårdgivare vilket ger upphov till variation varför ledtiden skall tolkas med försiktighet.
      <p></p>
      Andelen preoperativt behandlade patienter varierar i landet och före start av behandling görs flera undersökningar som kan förlänga tiden till start. Många patienter som startar preoperativ onkologisk behandling ingår i behandlingsstudier där vissa undersökningar är obligatoriska som annars hade gjorts senare. Siffrorna skall därför tolkas med viss försiktighet.
      <p></p>",
      MisstCa,
      "<p></p>",
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
  propWithinValue = 28,
  targetValues = GLOBALS$TARGET
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
