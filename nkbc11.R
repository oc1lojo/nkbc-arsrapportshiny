######################################################
# Project: Årsrapport
NAME <- "nkbc11"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated: se git 
######################################################


# Bröstbevarande operation ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Bröstbevarande operation", 
                      POP = "primärt opererade fall med invasiv cancer <=30 mm eller ej invasiv cancer <=20 mm utan fjärrmetastaser vid diagnos.",
                      SHORTPOP = "primärt opererade fall med små tumörer utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "op_inr_sjhkod",
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
    prim_op == 1,
    
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,
    
    # Exkludera fall som ej op i bröstet eller missing
    op_kir_brost_Värde %in% c(1, 2, 4),
    
    # Extent <= 30mm (invasiv) resp 20mm (in situ)
    (max_extent <= 30 & invasiv == "Invasiv cancer" |
       max_extent <= 20 & invasiv == "Enbart cancer in situ"),
    
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
      "Ett bröstbevarande ingrepp och  strålbehandling är  standradingrepp  för majoriten av tidigt upptäckta bröstcancrar . Tumörens egenskaper, form och storlek på bröstet spelar roll för av av kirurgisk operationsmetod.", 
      descTarg()
    ),
    descTolk, 
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
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))