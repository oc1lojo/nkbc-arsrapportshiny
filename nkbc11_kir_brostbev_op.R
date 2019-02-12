nkbc11_def <- list(
  code = "nkbc11",
  lab = "Bröstbevarande operation",
  pop = "primärt opererade fall med invasiv cancer <=30 mm eller ej invasiv cancer <=20 mm utan fjärrmetastaser vid diagnos",
  pop_short = "primärt opererade fall med små tumörer utan fjärrmetastaser vid diagnos",
  target_values = c(70, 80),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Ett bröstbevarande ingrepp och  strålbehandling är  standradingrepp  för majoriten av tidigt upptäckta bröstcancrar . Tumörens egenskaper, form och storlek på bröstet spelar roll för av av kirurgisk operationsmetod.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc11_def$sjhkod_var) %>%
  mutate(
    max_extent = pmax(op_pad_extentx, op_pad_extenty, na.rm = TRUE),
    outcome = ifelse(op_kir_brost_Värde == 1, TRUE, FALSE)
  ) %>%
  filter(
    # Extent infördes mitten av 2014
    period >= 2015,

    # Endast primär opereration (planerad om utförd ej finns)
    d_prim_beh_Värde == 1,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    # Exkludera fall som ej op i bröstet eller missing
    op_kir_brost_Värde %in% c(1, 2, 4),

    # Extent <= 30mm (invasiv) resp 20mm (in situ)
    (max_extent <= 30 & d_invasiv == "Invasiv cancer" |
      max_extent <= 20 & d_invasiv == "Enbart cancer in situ"),

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc11_def$code,
  path = output_path,
  outcomeTitle = nkbc11_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc11_def),
  description = compile_description(nkbc11_def, report_end_year),
  varOther = compile_varOther(nkbc11_def),
  targetValues = nkbc11_def$target_values
)
