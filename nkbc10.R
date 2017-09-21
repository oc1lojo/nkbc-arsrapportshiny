######################################################
# Project: Årsrapport 2016
NAME <- "nkbc10"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Fullständig patologirapport (Grad, ER, PR, HER2, Ki67) ------------------------------------------------
GLOBALS <- defGlobals(LAB = "Fullständig patologirapport (Grad, ER, PR, HER2, Ki67)",
                      POP = "primärt opererade fall med invasiv cancer utan fjärrmetastaser vid diagnos.",
                      SHORTLAB = "Fullständig patologirapport",
                      SJHKODUSE <- "a_kir_sjhkod",
                      TARGET = c(95, 98)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    d_op_nhgok = op_pad_nhg_Värde %in% c(1, 2, 3), 
    d_op_erok = op_pad_er_Värde %in% c(1, 2) | !is.na(op_pad_erproc), 
    d_op_prok = op_pad_pr_Värde %in% c(1, 2) | !is.na(op_pad_prproc), 
    d_op_herok = op_pad_her2_Värde %in% c(1, 2, 3) | op_pad_her2ish_Värde %in% c(1, 2), 
    # Ki67 tillkom som nationell variabel 2014
    d_op_ki67ok = (op_pad_ki67_Värde %in% c(1, 2, 3) | !is.na(op_pad_ki67proc)) | period <= 2013, 
    
    outcome = d_op_nhgok & d_op_erok & d_op_prok & d_op_herok & d_op_ki67ok
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat), 
    
    # Endast planerad primär opereration
    a_planbeh_typ_Värde %in% c(1),
    
    # Endast invasiv cancer
    invasiv == "Invasiv",
    
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
      "Patologirapporten grundas i mikroskopiska vävnadsanalyser. Biomarkörerna etablerar grunden till den onkologiska behandlingen av bröstcancer (endokrin-, cytostatika-  eller antikroppsbehandling).", 
      descTarg()
    ),
    paste0(
      "Ki67 tillkom som nationell variabel 2014 och ingår ej i beräkning innan detta datum.
      <p></p>", 
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