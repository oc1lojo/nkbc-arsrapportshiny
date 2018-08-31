NAME <- "nkbc094"

GLOBALS <- defGlobals(
  LAB = "Biologisk subtyp vid diagnos",
  SHORTLAB = "Biologisk subtyp",
  POP = "invasiva fall.",
  SJHKODUSE = "a_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = subtyp
  ) %>%
  filter(
    # Endast invasiv cancer
    invasiv == "Invasiv cancer",

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
    "Invasiv bröstcancer delas in i grupper, subtyper, enligt tumörens biologiska egenskaper, Luminal, HER2-positiv och trippelnegativ. De olika subtyperna är känsliga för olika behandlingar.
    <p></p>
    Luminal – tumörer som uttrycker östrogenreceptorer (ER) och/eller progesteronreceptorer (PgR), det vill säga, är ER-positiva och/ eller PgR positiva.
    <p></p>
    HER2-positiva – tumörer har många kopior av HER2-genen (amplifiering) vilket leder till en ökning av antalet HER2-receptorer på cellytan. Detta i sin tur stimulerar till snabb tillväxt.
    <p></p>
    Trippelnegativ – tumörer saknar östrogenreceptorer (ER) och progesteronreceptorer (PgR) och överuttrycker inte HER2. Den är varken hormonkänslig eller känslig för behandling riktad mot HER2-receptorn.",
    descTolk,
    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  )
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
