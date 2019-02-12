GLOBALS <- defGlobals(
  LAB = "Patienten ingår i studie",
  POP = "opererade fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "post_inr_sjhkod"
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, GLOBALS$SJHKODUSE) %>%
  mutate(
    # Hantera missing
    a_beh_studie = as.logical(ifelse(a_beh_studie_Värde %in% c(0, 1), a_beh_studie_Värde, NA)),
    pre_beh_studie = as.logical(ifelse(pre_beh_studie_Värde %in% c(0, 1), pre_beh_studie_Värde, NA)),
    post_beh_studie = as.logical(ifelse(post_beh_studie_Värde %in% c(0, 1), post_beh_studie_Värde, NA)),
    # Beräkna indikator
    outcome =
      case_when(
        a_beh_studie | pre_beh_studie | post_beh_studie ~ TRUE,
        !a_beh_studie | !pre_beh_studie | !post_beh_studie ~ FALSE
      )
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
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = "nkbc39",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      paste(
        "Ett övergripande mål är att erbjuda alla bröstcancerpatienter medverkan i studier för att utveckla nya behandlingar och arbetssätt.",
        "Indikatorn gäller alla typer av studier (t.ex. kliniska studier, omvårdnadsstudier, fysioterapi-studier).",
        "Indikatorn infördes 2017 och bör tolkas med försiktighet (regionala skillnader och underrapportering)."
      ),
      sep = str_sep_description
    ),
    paste(
      onkRed,
      descTolk,
      sep = str_sep_description
    ),
    paste(
      descTekBes(),
      sep = str_sep_description
    )
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    ),
    list(
      var = "d_invasiv",
      label = c("Invasivitet vid diagnos")
    )
  )
)
