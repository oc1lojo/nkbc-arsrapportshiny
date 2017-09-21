######################################################
# Project: Årsrapport 2016
NAME <- "nkbc27"
# Created by: Lina Benson 
# Created date: 2017-08-10
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Postoperativ cytostatikabehandling ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Postoperativ cytostatikabehandling",
                      POP = "primärt opererade östrogenreceptor negativa invasiva fall med tumörstorlek > 10mm eller spridning till lymfkörtlar utan fjärrmetastaser vid diagnos.",
                      SHORTPOP = "primärt opererade ER- invasiva fall med större tumörer utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "a_onk_sjhkod",
                      TARGET = c(80, 90)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = as.logical(post_kemo_Värde)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,
    
    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,
    
    # Endast opererade
    !is.na(op_kir_dat),
    
    # Endast planerad primär opereration (pga att info om tumörstorlek och spridning till N behövs)
    a_planbeh_typ_Värde %in% c(1),
    
    # Endast invasiv cancer
    invasiv == "Invasiv",
    
    # ER-. Finns inga fjärrisar så behöver ej titta på PAD från anmälan
    er_op == 1,
    
    # Tumörstorlek > 10 mm eller spridning till lymfkörtlar
    (op_pad_invstl > 10 | op_pad_lglmetant > 0),

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
      "Cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer.",
      descTarg()
    ),
    paste0(
      "Enbart postoperativ cytostatikabehandling är medtaget i beräkningen, vilket innebär att andelen kan bli mindre för de sjukhus där cytostatika i större utsträckning ges preoperativt. 
      <p></p>
      Tumörstorlek är storlek på den största invasiva tumören, det innebär att det kan finnas multifokala fall där den totala extenten är > 10 mm som inte finns medtagna i urvalet.
      <p></p>
      Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen.
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