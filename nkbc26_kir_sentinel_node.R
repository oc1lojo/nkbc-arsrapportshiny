GLOBALS <- defGlobals(
  LAB = "Sentinel node operation",
  POP = "invasiva fall utan spridning till lymfkörtlar (klinisk diagnos) eller fjärrmetastaser vid diagnos.",
  SHORTPOP = "invasiva fall utan spridning till lymfkörtlar eller fjärrmetastaser vid diagnos.",
  SJHKODUSE = "op_inr_sjhkod",
  TARGET = c(90, 95)
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, GLOBALS$SJHKODUSE) %>%
  mutate(
    outcome = case_when(
      op_kir_axilltyp_Värde == 1 ~ 1L,
      op_kir_axilltyp_Värde == 2 ~ 0L,
      op_kir_axilltyp_Värde == 3 ~ 1L,
      op_kir_axilltyp_Värde == 4 ~ 0L,
      op_kir_axilltyp_Värde == 98 ~ NA_integer_,
      TRUE ~ NA_integer_
    ),
    outcome = as.logical(ifelse(op_kir_axill_Värde %in% 0, 0, outcome))
  ) %>%
  filter(
    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # Klinisk N0
    a_tnm_nklass_Värde == 0,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = "nkbc26",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      paste(
        "Kännedom om tumörspridning till axillens lymfkörtlar vägleder behandlingsrekommendationer.",
        "Sentinelnodetekniken minskar risken för armbesvär då endast ett fåtal (1–4) körtlar tas bort."
      ),
      descTarg(),
      sep = str_sep_description
    ),
    paste(
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
    )
  ),
  targetValues = GLOBALS$TARGET
)
