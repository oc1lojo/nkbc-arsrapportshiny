######################################################
# Project: Årsrapport 2016
NAME <- "nkbc31"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Endokrin behandling ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Endokrin behandling",
                      POP = "opererade östrogenreceptor positiva invasiva fall utan fjärrmetastaser vid diagnos.",
                      SHORTPOP = "opererade ER+ invasiva fall utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "a_onk_sjhkod",
                      TARGET = c(90, 95)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Går på det som finns, pre eller postop. Om det ena saknas antas samma som finns för det andra.
    outcome = as.logical(pmax(post_endo_Värde, pre_endo_Värde, na.rm = TRUE))
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
    
    # ER+. Finns inga fjärrisar så behöver ej titta på PAD från anmälan
    er_op == 1,
    
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
      "Endokrin behandling bör erbjudas till alla patienter med östrogenreceptorpositiv (ER+) bröstcancer. I de fall där samsjuklighet föreligger får nyttan med endokrin behandling avvägas.", 
      descTarg()
    ),
    paste0(
      "Både preoperativ och postoperativ endokrin behandling är medtaget i beräkningen.
      <p></p>
      Här presenteras data för påbörjad behandling. Det finns studier som visar att ca 70% av patienterna stoppar eller gör längre avbrott i sin endokrina behandling i huvudsak pga biverkningar.
      <p></p>",
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