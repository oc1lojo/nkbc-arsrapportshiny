nkbc43 <- list(
  code = "nkbc43",
  lab = "Välgrundad misstanke om cancer till primär behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Endast fall med år från 2013 (1:a kontakt tillkom 2013)
      year(a_diag_dat) >= 2013,

      # Endast opererade
      !is.na(op_kir_dat),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      d_a_diag_misscadat = ymd(coalesce(a_diag_misscadat, a_diag_kontdat)),
      d_pre_onk_dat = pmin(ymd(pre_kemo_dat),
        ymd(pre_rt_dat),
        ymd(pre_endo_dat),
        na.rm = TRUE
      ),
      d_prim_beh_dat = case_when(
        d_prim_beh_Värde == 1 ~ ymd(op_kir_dat),
        d_prim_beh_Värde == 2 ~ d_pre_onk_dat,
        TRUE ~ ymd(NA_character_)
      ),
      outcome = as.numeric(d_prim_beh_dat - d_a_diag_misscadat),
      outcome = ifelse(outcome < 0, 0, outcome)
    )
  },
  prop_within_value = 28,
  target_values = c(80),
  sjhkod_var = "d_prim_beh_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv", "d_prim_beh"),
  om_indikatorn =
    paste(
      "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och start av behandling till patienter i rimlig tid.",
      "För bröstcancer är tiden från välgrundad misstanke till start av behandling 28 kalenderdagar.",
      "Av patienter som utreds för cancer bör 80% ha gjort det inom denna tidsperiod.",
      "För ett antal patienter krävs mer avancerade utredningsmetoder för att nå diagnos vilket kan förlänga tiden till behandlingsstart.",
      "Startpunkten för SVF har tolkats olika av vårdgivare vilket ger upphov till variation varför ledtiden skall tolkas med stor försiktighet."
    ),
  vid_tolkning = NULL,
  inkl_beskr_missca = TRUE,
  teknisk_beskrivning = NULL
)
class(nkbc43) <- "nkbcind"

filter_nkbc43_pop <- nkbc43$filter_pop
mutate_nkbc43_outcome <- nkbc43$mutate_outcome
