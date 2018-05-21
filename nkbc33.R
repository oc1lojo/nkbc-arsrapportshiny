######################################################
# Project: Årsrapport
NAME <- "nkbc33"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated: se git
######################################################


# Täckningsgrad, anmälan till kvalitetsregistret ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Täckningsgrad mot cancerregistret", 
                      POP = "alla anmälda fall.",
                      SJHKODUSE <- "a_inr_sjhkod", 
                      TARGET = c(95, 99)
                      )

tack <- readxl::read_excel("G:/Hsf/RCC-Statistiker/Brostcancer/Brostcancer/Utdata/Arsrapport/2017 april/Täckningsgrader/Tackningsrader_alla_regioner.xlsx")
dftemp <- data.frame(region = c(rep(tack$region, tack$finns), rep(tack$region, tack$ejfinns)),
                    period = c(rep(tack$ar, tack$finns), rep(tack$ar, tack$ejfinns)),
                    outcome = c(rep(rep(TRUE, dim(tack)[1]), tack$finns), rep(rep(FALSE, dim(tack)[1]), tack$ejfinns))
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
#runApp(paste0("Output/apps/sv/",NAME))