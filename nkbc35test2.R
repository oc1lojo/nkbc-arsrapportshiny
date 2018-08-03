######################################################
# Project: Årsrapport
NAME <- "nkbc35test2"
# Created by: Lina Benson 
# Created date: 2017-08-10
# Software: R x64 v 3.3.3
# Status: Final
# Updated: se git
######################################################


# Cytostatikabehandling ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Cytostatikabehandling",
                      POP = "opererade, invasiva fall utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "d_onk_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Pre eller postoperativ
    outcome = factor(case_when(
      post_kemo_Värde == 1 & pre_kemo_Värde == 1 ~ 3,
      pre_kemo_Värde == 1 ~ 1,
      post_kemo_Värde == 1 ~ 2,
      post_kemo_Värde == 0 | pre_kemo_Värde == 0 ~ 0
    ),
    levels = c(0, 1, 2, 3),
    labels = c("Ingen", 
               "Enbart preoperativ", 
               "Enbart postoperativ",
               "Både pre-och postoperativ")
    ),
    
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
    er = factor(er, c(1, 2, 99), c("Positiv", "Negativ", "Uppgift saknas"))
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
    
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv, 
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
      "Pre- eller postoperativ cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer."
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
      var = "a_pat_alder",
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