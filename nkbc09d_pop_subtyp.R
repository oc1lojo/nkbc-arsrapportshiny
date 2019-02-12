GLOBALS <- defGlobals(
  LAB = "Biologisk subtyp vid diagnos",
  SHORTLAB = "Biologisk subtyp",
  POP = "invasiva fall.",
  SJHKODUSE = "a_inr_sjhkod"
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, GLOBALS$SJHKODUSE) %>%
  mutate(
    outcome = d_subtyp
  ) %>%
  filter(
    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = "nkbc09d",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      "Invasiv bröstcancer delas in i grupper, subtyper, enligt tumörens biologiska egenskaper, Luminal, HER2-positiv och trippelnegativ. De olika subtyperna är känsliga för olika behandlingar.",
      "Luminal – tumörer som uttrycker östrogenreceptorer (ER) och/eller progesteronreceptorer (PgR), det vill säga, är ER-positiva och/ eller PgR positiva.",
      "HER2-positiva – tumörer har många kopior av HER2-genen (amplifiering) vilket leder till en ökning av antalet HER2-receptorer på cellytan. Detta i sin tur stimulerar till snabb tillväxt.",
      "Trippelnegativ – tumörer saknar östrogenreceptorer (ER) och progesteronreceptorer (PgR) och överuttrycker inte HER2. Den är varken hormonkänslig eller känslig för behandling riktad mot HER2-receptorn.",
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
  )
)
