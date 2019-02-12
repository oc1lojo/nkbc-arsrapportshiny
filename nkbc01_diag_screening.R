GLOBALS <- defGlobals(
  LAB = "Screeningupptäckt bröstcancer",
  POP = "kvinnor i åldrarna 40-74 år vid diagnos.",
  SJHKODUSE = "a_inr_sjhkod",
  TARGET = c(60, 70)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    a_pat_alder = as.numeric(a_pat_alder),

    # Hantera missing
    outcome = as.logical(ifelse(a_diag_screening_Värde %in% c(0, 1), a_diag_screening_Värde, NA))
  ) %>%
  filter(
    # Ålder 40-74 år vid diagnos
    a_pat_alder <= 74,
    a_pat_alder >= 40,

    # Enbart kvinnor
    KON_VALUE == 2,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = "nkbc01",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      "Mammografiscreening erbjuds alla kvinnor mellan 40–74 år.",
      descTarg(),
      sep = str_sep_description
    ),
    paste(
      paste(
        "Definitionen av \"screeningupptäckt fall\" kan enligt erfarenhet tolkas olika vilket kan påverka siffrorna.",
        "Enligt kvalitetsregistret avses enbart de fall som diagnostiserats i samband med en kallelse till den landstingsorganiserade screeningmammografin."
      ),
      "Det finns en osäkerhet avseende andel screeningupptäckta fall då det på vissa orter bara finns en mammografienhet som både utför screening och klinisk mammografi.",
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
    ),
    list(
      var = "d_invasiv",
      label = c("Invasivitet vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)
