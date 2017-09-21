######################################################
# Project: Årsrapport 2016
NAME <- "nkbc35"
# Created by: Lina Benson 
# Created date: 2017-08-10
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Cytostatikabehandling ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Cytostatikabehandling",
                      POP = "opererade, invasiva fall utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "a_onk_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = as.logical(pmax(post_kemo_Värde, pre_kemo_Värde, na.rm = TRUE)),
    
    # T
    Tstad = factor(
      mapvalues(a_tnm_tklass_Värde, 
                from = c(0, 5, 10, 20, 30, 42, 44, 45, 46, 50, NA), 
                to = c(1, 1, 1, 2, 2, 2, 2, 2, 2, 99, 99)
                ),
      levels = c(1, 2, 99),
      labels = c("<=20mm (T0/T1)", ">20mm (T2-T4)", "Uppgift saknas")
    ),
    
    # N
    Nstad = factor(
      mapvalues(a_tnm_nklass_Värde, 
                from = c(0, 10, 20, 30, 40, NA), 
                to = c(1, 2, 2, 2, 99, 99)
                ),
      levels = c(1, 2, 99),
      labels = c("Nej (N0)", "Ja (N1-N3)", "Uppgift saknas")
    ),
      
    # ER
    er = ifelse(is.na(er), 99, er),
    er = factor(er, c(1, 2, 99), c("Negativ", "Positiv", "Uppgift saknas"))
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
    
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% c(10),
    !a_planbeh_typ_Värde %in% c(3),
    
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, agegroup, invasiv, 
         er, Tstad, Nstad)


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
      "Cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer.",
      descTarg()
    ),
    paste0(
      "Både preoperativ och postoperativ cytostatikabehandling är medtaget i beräkningen.
      <p></p>
      Tumörstorlek och spridning till lymfkörtlar är kliniskt diagnostiserat. 
      <p></p>
      För fall med preoperativ onkologisk behandling är östrogenreceptoruttryck hämtat från nålsbiopsi innan behandling, i övriga fall från operation. 
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
    ),
    list(
      var = "Tstad",
      label = c("Tumörstorlek")
    ),
    list(
      var = "Nstad",
      label = c("Spridning till lymfkörtlar")
    ),
    list(
      var = "er",
      label = c("Östrogenreceptor (ER)")
    )
  )
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))