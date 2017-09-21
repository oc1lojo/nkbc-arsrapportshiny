######################################################
# Project: Årsrapport 2016
NAME <- "nkbc28"
# Created by: Lina Benson 
# Created date: 2017-08-10
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Strålbehandling efter bröstbevarande operation ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Strålbehandling efter bröstbevarande operation",
                      POP = "invasiva fall med bröstbevarande operation utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "a_onk_sjhkod",
                      TARGET = c(90, 95)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = as.logical(post_rt_Värde)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,
    
    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,
    
    # Endast opererade
    !is.na(op_kir_dat),
    
    # Endast invasiv cancer
    invasiv == "Invasiv",
    
    # Endast bröstbevarande operation
    op_kir_brost_Värde %in% c(1),
    
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% c(10),
    !a_planbeh_typ_Värde %in% c(3),
    
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
      "Strålbehandling efter operation minskar risk för återfall. I de fall där samsjuklighet föreligger får nyttan med strålbehandling avvägas.", 
      descTarg()
    ),
    paste0(
      onkRed,
      "<p></p>",
      descTolk
    ),
    descTekBes()
  ),
  varOther = list(
    list(
      var = "agegroup",
      label = c("Ålder vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))