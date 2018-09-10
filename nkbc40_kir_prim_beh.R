NAME <- "nkbc40"

GLOBALS <- defGlobals(
  LAB = "Typ av primär behandling",
  POP = "opererade fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "op_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Prim op eller preop onk beh
    outcome = factor(prim_beh,
      levels = c(1, 2),
      labels = c(
        "Primär operation",
        "Preoperativ onkologisk behandling"
      )
    ),

    # N
    Nstad = factor(
      mapvalues(a_tnm_nklass_Värde,
        from = c(0, 10, 20, 30, 40, NA),
        to = c(1, 2, 2, 2, 99, 99)
      ),
      levels = c(1, 2, 99),
      labels = c("Nej (N0)", "Ja (N1-N3)", "Uppgift saknas")
    )
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv, Nstad, subtyp)

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
      "Preoperativ (neoadjuvant) onkologisk behandling är aktuellt när reduktion av primärtumören önskas inför kirurgi och/eller utvärdering av behandlingseffekten med tumören kvar är en fördel.",
      "Tumörstorlek, spridning till lymfkörtlarna liksom biologisk subtyp påverkar val av preoperativ behandling eller ej, liksom typ av preoperativ behandling."
    ),
    paste0(
      "För fall med preoperativ onkologisk behandling är östrogenreceptoruttryck hämtat från nålsbiopsi innan behandling, i övriga fall från operation.
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
      var = "subtyp",
      label = c("Biologisk subtyp")
    ),
    list(
      var = "Nstad",
      label = c("Spridning till lymfkörtlar")
    )
  )
)

cat(link, fill = TRUE)
# runApp(paste0("Output/apps/sv/",NAME))
