######################################################
# Project: Årsrapport 2016
NAME <- "nkbc34"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Täckningsgrad för rapportering av 5 års uppföljning ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Täckningsgrad för rapportering av 5 års uppföljning",
                      POP = "alla anmälda fall utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "d_uppfans_sjhkod",
                      TARGET = c(70, 85)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    d_uppf_dat = pmax(u_dat, r_dat, na.rm = TRUE),
    tdia2uppf = ymd(d_uppf_dat) - ymd(a_diag_dat),
    outcome = tdia2uppf > 4.5*365.25 & !is.na(tdia2uppf)
  ) %>%
  filter(
    # 5 år bakåt då info om 5 års uppf
    period <= YEAR - 5,
    
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% c(10),

    !is.na(region)
    
  ) %>%
  select(landsting, region, sjukhus, period, outcome, agegroup, invasiv)


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
      "På 5-års uppföljningen rapporteras endokrin behandling.", 
      descTarg()
    ),
    paste0(
      "Rapporterad 5 års uppföljning defineras som rapporterad uppföljning eller recidiv/metastas minst 4.5 år från diagnos.
      Uppgifter som rör 5 års uppföljningen redovisas enbart tom ",YEAR - 5,".
      <p></p>",
      descTolk
    ),
    descTekBes()
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))