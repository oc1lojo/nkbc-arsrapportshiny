nkbcproto009 <- list(
  code = "nkbcproto009",
  lab = "Observerad 5 års överlevnad (PROTOTYP)",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    dplyr::filter(
      x,
      lubridate::year(a_diag_dat) <= lubridate::year(lubridate::today()) - 6
    )
  },
  mutate_outcome = function(x, ...) {
    dplyr::mutate(x,
      # lastdate = lubridate::ymd(paste0(report_end_year, "-12-31")),
      lastdate = lubridate::ymd(paste0(year(lubridate::today()) - 1, "-12-31")),
      surv_time = lubridate::ymd(VITALSTATUSDATUM_ESTIMAT) - lubridate::ymd(a_diag_dat),
      outcome = surv_time >= 365.25 * 5
    )
  },
  sjhkod_var = "a_inr_sjhkod",
  geo_units_vars = "region", # OBS Ingen redovisning på sjukhus- eller regionnivå
  other_vars = c("a_pat_alder", "d_invasiv", "d_trigrp", "d_tstad", "d_nstad", "d_mstad"),
  om_indikatorn =
    paste(
      "Total överlevnad betraktas som det viktigaste utfallsmåttet.",
      "Dödsorsakerna kan vara andra än bröstcancer.",
      "Observerad överlevnad anger de bröstcancerfall som överlevt 5 år efter diagnos.",
      "Observera att analysen inte är justerad för skillnader i population."
    ),
  vid_tolkning = NULL,
  inkl_beskr_overlevnad_5ar = TRUE,
  teknisk_beskrivning = NULL
)
class(nkbcproto009) <- "nkbcind"
