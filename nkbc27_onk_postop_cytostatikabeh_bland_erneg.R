NAME <- "nkbc27"

GLOBALS <- defGlobals(
  LAB = "Postoperativ cytostatikabehandling",
  POP = "primärt opererade östrogenreceptornegativa invasiva fall med tumörstorlek > 10mm eller spridning till lymfkörtlar utan fjärrmetastaser vid diagnos.",
  SHORTPOP = "primärt opererade ER- invasiva fall med större tumörer utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "post_inr_sjhkod",
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

    # Endast primär opereration (planerad om utfärd ej finns)
    # (pga att info om tumörstorlek och spridning till N behövs)
    prim_op == 1,

    # Endast invasiv cancer
    invasiv == "Invasiv cancer",

    # ER-
    er == 2,

    # Tumörstorlek > 10 mm eller spridning till lymfkörtlar
    (op_pad_invstl > 10 | op_pad_lglmetant > 0),

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
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
