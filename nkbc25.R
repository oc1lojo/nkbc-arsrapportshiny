NAME <- "nkbc25"

# Patienten ingår i postoperativ studie ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Patienten ingår i postoperativ studie",
                      POP = "opererade fall utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "post_inr_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(post_beh_studie_Värde %in% c(0, 1), post_beh_studie_Värde, NA))
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
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    ),
    list(
      var = "invasiv",
      label = c("Invasivitet vid diagnos")
    )
  )
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))