NAME <- "nkbc33"

GLOBALS <- defGlobals(
  LAB = "Täckningsgrad mot cancerregistret",
  POP = "alla anmälda fall.",
  SJHKODUSE <- "a_inr_sjhkod",
  TARGET = c(95, 99)
)

dftemp <- data.frame(
  region = c(
    rep(tackning_tbl$region, tackning_tbl$finns),
    rep(tackning_tbl$region, tackning_tbl$ejfinns)
  ),
  period = c(
    rep(tackning_tbl$ar, tackning_tbl$finns),
    rep(tackning_tbl$ar, tackning_tbl$ejfinns)
  ),
  outcome = c(
    rep(rep(TRUE, dim(tackning_tbl)[1]), tackning_tbl$finns),
    rep(rep(FALSE, dim(tackning_tbl)[1]), tackning_tbl$ejfinns)
  )
)

link <- rccShiny(
  data = dftemp,
  folder = NAME,
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste0(
      "Anmälan till cancerregistret och anmälan till kvalitetsregistret är kombinerade och därmed undviks dubbelarbete.",
      descTarg()
    ),
    ettFallBrost,
    paste0(
      "Population: ", GLOBALS$POP,
      "<p></p>
      Uppgifterna redovisas uppdelat på den region personen var bosatt i vid diagnos."
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
