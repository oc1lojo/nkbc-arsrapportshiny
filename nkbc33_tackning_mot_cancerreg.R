GLOBALS <- defGlobals(
  LAB = "Täckningsgrad mot cancerregistret",
  POP = "alla anmälda fall.",
  SJHKODUSE = "a_inr_sjhkod",
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

rccShiny(
  data = dftemp,
  folder = "nkbc33",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      "Anmälan till cancerregistret och anmälan till kvalitetsregistret är kombinerade och därmed undviks dubbelarbete.",
      descTarg(),
      sep = str_sep_description
    ),
    paste(
      ettFallBrost,
      sep = str_sep_description
    ),
    paste(
      paste("Population:", GLOBALS$POP),
      "Uppgifterna redovisas uppdelat på den region personen var bosatt i vid diagnos.",
      sep = str_sep_description
    )
  ),
  targetValues = GLOBALS$TARGET
)
