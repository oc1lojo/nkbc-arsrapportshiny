######################################################
# Project: Årsrapport 2016
NAME <- "nkbc24"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Patienten ingår i preoperativ studie ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Patienten ingår i preoperativ studie",
                      POP = "fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling.",
                      SJHKODUSE <- "a_onk_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(pre_beh_studie_Värde %in% c(0,1), pre_beh_studie_Värde, NA))
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,
    
    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,
    
    # Endast opererade
    !is.na(op_kir_dat), 
    
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
    "Ett övergripande mål är att erbjuda alla bröstcancerpatienter medverkan i studier för att utveckla nya behandlingar och arbetssätt. Detta gäller alla typer av studier (t.ex. kliniska, omvårdnad, fysioterapi).", 
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
    ),
    list(
      var = "invasiv",
      label = c("Invasivitet")
    )
  )
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))