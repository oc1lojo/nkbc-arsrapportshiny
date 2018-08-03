NAME <- "nkbc14"

# Täckningsgrad för rapportering av postoperativ onkologisk behandling ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Täckningsgrad för rapportering av postoperativ onkologisk behandling",
                      POP = "opererade fall utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "d_onkpostans_sjhkod",
                      TARGET = c(70, 85)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = ifelse(!is.na(post_inr_dat) | !is.na(post_inr_enh) | !is.na(post_inr_initav), TRUE, FALSE)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,
    
    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,
    
    # Endast opererade
    !is.na(op_kir_dat), 

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
      "Rapportering av given onkologisk behandling sker på ett eget formulär till kvalitetsregistret, separat från anmälan. Rapporteringen sker cirka 1 - 1,5 år efter anmälan.", 
      descTarg()
    ),
    paste0(
      onkRed,
      "<p></p>",
      descTolk
    ),
    descTekBes()
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))