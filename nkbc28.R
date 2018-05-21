######################################################
# Project: Årsrapport
NAME <- "nkbc28"
# Created by: Lina Benson 
# Created date: 2017-08-10
# Software: R x64 v 3.3.3
# Status: 
# Updated: se git
######################################################


# Strålbehandling efter bröstbevarande operation ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Strålbehandling efter bröstbevarande operation",
                      POP = "invasiva fall med bröstbevarande operation utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "post_inr_sjhkod",
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
    invasiv == "Invasiv cancer",
    
    # Endast bröstbevarande operation
    op_kir_brost_Värde == 1,
    
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
      "Strålbehandling efter bröstbevarande operation minskar risk för återfall. I de fall där samsjuklighet föreligger får nyttan med strålbehandling avvägas med hänsyn till övriga medicinska faktorer.", 
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
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))