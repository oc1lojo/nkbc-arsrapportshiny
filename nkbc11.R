######################################################
# Project: Årsrapport 2016
NAME <- "nkbc11"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Bröstbevarande operation ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Bröstbevarande operation", 
                      POP = "primärt opererade fall med invasiv cancer <=30 mm eller ej invasiv cancer <=20 mm utan fjärrmetastaser vid diagnos.",
                      SHORTPOP = "primärt opererade fall med små tumörer utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "a_kir_sjhkod",
                      TARGET = c(70, 80)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    max_extent = pmax(op_pad_extentx, op_pad_extenty, na.rm = TRUE), 
    outcome = ifelse(op_kir_brost_Värde == 1, TRUE, FALSE)     
  ) %>%
  filter(
    # Extent infördes mitten av 2014
    period >= 2015,  
    
    # Endast primär opereration (planerad om utförd ej finns)
    (op_kir_Värde %in% 1 | is.na(op_kir_Värde) & a_planbeh_typ_Värde %in% 1),
    
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% c(10),
    
    # Exkludera fall som ej op i bröstet eller missing
    !(op_kir_brost_Värde %in% 3 | is.na(op_kir_brost_Värde)),
    
    # Extent <= 30mm (invasiv) resp 20mm (in situ)
    (max_extent <= 30 & invasiv == "Invasiv" |
       max_extent <= 20 & invasiv == "Ej invasiv"),
    
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
      "Bröstbevarande operation rekommenderas som förstahandsoperation vid mindre eller medelstor tumörutbredning.", 
      descTarg()
    ),
    descTolk, 
    descTekBes()
  ),
  varOther = list(
    list(
      var = "agegroup",
      label = c("Ålder vid diagnos")
    ),
    list(
      var = "invasiv",
      label = c("Invasivitet")
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))
