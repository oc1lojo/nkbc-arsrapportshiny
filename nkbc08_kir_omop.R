GLOBALS <- defGlobals(
  LAB = "Enbart en operation (ingen omoperation p.g.a. tumördata) i bröst",
  POP = "opererade fall utan fjärrmetastaser vid diagnos.",
  SHORTLAB = "Enbart en operation",
  SJHKODUSE = "op_inr_sjhkod",
  TARGET = c(80, 90)
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, GLOBALS$SJHKODUSE) %>%
  mutate(
    # Hantera missing
    outcome = ifelse(op_kir_sekbrost_Värde %in% c(0, 1), op_kir_sekbrost_Värde, NA),

    outcome = as.logical(!outcome)
  ) %>%
  filter(
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = "nkbc08",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      "Om det vid analys av den bortopererade vävnaden visar sig att tumörvävnad kan ha kvarlämnats blir patienten ofta rekommenderad en omoperation.",
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
    ),
    list(
      var = "d_invasiv",
      label = c("Invasivitet vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)
