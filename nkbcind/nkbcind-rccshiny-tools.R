compile_textBeforeSubtitle <- function(x, ...) {
  paste0(
    "Bland ",
    if_else(is.null(x$pop_short), x$pop, x$pop_short),
    "."
  )
}

compile_description <- function(x, report_end_year = report_end_year, ...) {
  c(
    # Om indikatorn
    paste(
      c(
        x$om_indikatorn,
        if (!is.null(x$target_values)) {
          case_when(
            length(x$target_values) == 1 ~
              paste0("Målnivå: ", x$target_values[1], "%"),
            length(x$target_values) == 2 ~
              paste0("Målnivåer: ", x$target_values[1], "% (låg) ", x$target_values[2], "% (hög)")
          )
        }
      ),
      collapse = "</br>\n</br>\n"
    ),
    # Vid tolkning
    paste(
      c(
        x$vid_tolkning,
        if (!is.null(x$inkl_beskr_missca) && x$inkl_beskr_missca == TRUE) {
          "Datum för välgrundad misstanke om cancer tillkom som variabel 2016 och innan detta har datum för 1:a kontakt använts."
        },
        if (!is.null(x$inkl_beskr_onk_beh) && x$inkl_beskr_onk_beh == TRUE) {
          paste(
            "Uppgifter som rör given onkologisk behandling redovisas enbart t.o.m.",
            report_end_year - 1, "p.g.a. eftersläpning i rapporteringen."
          )
        },
        paste(
          "Ett fall per bröst kan rapporterats till det nationella kvalitetsregistret för bröstcancer.",
          "Det innebär att samma person kan finnas med i statistiken upp till två gånger."
        ),
        "Skövde och Lidköpings sjukhus presenteras tillsammans som Skaraborg."
      ),
      collapse = "</br>\n</br>\n"
    ),
    # Teknisk beskrivning
    paste(
      c(
        x$teknisk_beskrivning,
        paste0("Population: ", x$pop, "."),
        paste0(
          "Uppgifterna redovisas uppdelat på ",
          case_when(
            x$sjhkod_var %in% "a_inr_sjhkod" ~
              "anmälande sjukhus",
            x$sjhkod_var %in% c("post_inr_sjhkod", "pre_inr_sjhkod", "d_onk_sjhkod") ~
              "onkologiskt sjukhus",
            x$sjhkod_var %in% "op_inr_sjhkod" ~
              "opererande sjukhus",
            x$sjhkod_var %in% c("d_onkpreans_sjhkod", "d_onkpostans_sjhkod") ~
              "rapporterande onkologiskt sjukhus och om detta saknas sjukhus ansvarigt för rapportering av onkologisk behandling, onkologiskt sjukhus, anmälande sjukhus"
          ),
          "."
        )
      ),
      collapse = "</br>\n</br>\n"
    )
  )
}

compile_description_nkbc33 <- function(x, ...) {
  # Anpassad för rapporteringa av täckningsgrad mot cancerregistret (nkbc33)
  varOther <- c(
    # Om indikatorn
    paste(
      c(
        x$om_indikatorn,
        if (!is.null(x$target_values)) {
          case_when(
            length(x$target_values) == 1 ~
              paste0("Målnivå: ", x$target_values[1], "%"),
            length(x$target_values) == 2 ~
              paste0("Målnivåer: ", x$target_values[1], "% (låg) ", x$target_values[2], "% (hög)")
          )
        }
      ),
      collapse = "</br>\n</br>\n"
    ),
    # Vid tolkning
    paste(
      c(
        x$vid_tolkning,
        paste(
          "Ett fall per bröst kan rapporterats till det nationella kvalitetsregistret för bröstcancer.",
          "Det innebär att samma person kan finnas med i statistiken upp till två gånger."
        )
      ),
      collapse = "</br>\n</br>\n"
    ),
    # Teknisk beskrivning
    paste(
      c(
        x$teknisk_beskrivning,
        paste0("Population: ", x$pop, "."),
        "Uppgifterna redovisas uppdelat på den region personen var bosatt i vid diagnos."
      ),
      collapse = "</br>\n</br>\n"
    )
  )
}

compile_varOther <- function(x, varbesk = NULL, ...) {
  if (is.null(x$other_vars)) {
    return(NULL)
  } else {
    if (is.null(varbesk)) {
      varbesk <- tibble::enframe(
        c(
          a_pat_alder = "Ålder vid diagnos",
          d_tstad = "Tumörstorlek",
          d_nstad = "Spridning till lymfkörtlar",
          d_invasiv = "Invasivitet vid diagnos",
          d_pn = "Spridning till lymfkörtlar",
          d_er = "Östrogenreceptor (ER)",
          d_subtyp = "Biologisk subtyp"
        ),
        name = "var",
        value = "label"
      )
    }
    df <- left_join(tibble(var = x$other_vars), varbesk, by = "var")
    out <- list() # initialisera
    for (i in 1:nrow(df)) {
      out[[i]] <- as.list(df[i, ])
    }
    return(out)
  }
}
