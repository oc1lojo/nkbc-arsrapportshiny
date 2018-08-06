NAME <- "nkbc36"

GLOBALS <- defGlobals(
  LAB = "Typ av kirurgi",
  POP = "opererade fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE <- "op_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = factor(op_kir_brost_Värde,
      levels = c(1, 2, 3, 4),
      labels = c(
        "Ej bröstoperation",
        "Mastektomi",
        "Partiell mastektomi",
        "Subkutan mastektomi"
      )
    )
  ) %>%
  filter(
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
  comment = "Här skulle man kunna skriva lite kommentarer XXXYYYZZZ",
  description = c(
    paste0(
      "Här behövs det text."
    ),
    paste0(
      "För fall med preoperativ onkologisk behandling är östrogenreceptoruttryck hämtat från nålsbiopsi innan behandling, i övriga fall från operation. 
      <p></p>",
      descTolk
    ),
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
