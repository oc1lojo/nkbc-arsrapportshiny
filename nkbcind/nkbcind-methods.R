# Se t.ex. http://adv-r.had.co.nz/OO-essentials.html#s3

# Definiera generiska funktioner ----
code <- function(x) UseMethod("code")
lab <- function(x) UseMethod("lab")
lab_short <- function(x) UseMethod("lab_short")
pop <- function(x) UseMethod("pop")
pop_short <- function(x) UseMethod("pop_short")
prop_within_value <- function(x) UseMethod("prop_within_value")
target_values <- function(x) UseMethod("target_values")
sjhkod_var <- function(x) UseMethod("sjhkod_var")
other_vars <- function(x) UseMethod("other_vars")

textBeforeSubtitle <- function(x) UseMethod("textBeforeSubtitle")
description <- function(x, report_end_year = report_end_year) UseMethod("description")
varOther <- function(x) UseMethod("varOther")

# Definiera metoder för klasserna nkbcind och nkbc33 ----
code.nkbcind <- function(x) x$code
lab.nkbcind <- function(x) x$lab
lab_short.nkbcind <- function(x) ifelse(!is.null(x$lab_short), x$lab_short, x$lab)
pop.nkbcind <- function(x) x$pop
pop_short.nkbcind <- function(x) ifelse(!is.null(x$pop_short), x$pop_short, x$pop)
sjhkod_var.nkbcind <- function(x) x$sjhkod_var
prop_within_value.nkbcind <- function(x) x$prop_within_value
target_values.nkbcind <- function(x) x$target_values
other_vars.nkbcind <- function(x) x$other_vars

textBeforeSubtitle.nkbcind <- function(x, ...) {
  paste0("Bland ", pop_short(x), ".")
}

description.nkbcind <- function(x, report_end_year = report_end_year, ...) {
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
      collapse = "\n<p></p>\n"
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
        if (!is.null(x$inkl_beskr_overlevnad_5ar) && x$inkl_beskr_overlevnad_5ar == TRUE) {
          paste0("Uppgifter som rör 5 års överlevnad redovisas enbart t.o.m. ", report_end_year - 5, ".")
        },
        paste(
          "Ett fall per bröst kan rapporterats till det nationella kvalitetsregistret för bröstcancer.",
          "Det innebär att samma person kan finnas med i statistiken upp till två gånger."
        ),
        "Skövde och Lidköpings sjukhus presenteras tillsammans som Skaraborg."
      ),
      collapse = "\n<p></p>\n"
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
      collapse = "\n<p></p>\n"
    )
  )
}

description.nkbc33 <- function(x, report_end_year = report_end_year, ...) {
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
      collapse = "\n<p></p>\n"
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
      collapse = "\n<p></p>\n"
    ),
    # Teknisk beskrivning
    paste(
      c(
        x$teknisk_beskrivning,
        paste0("Population: ", x$pop, "."),
        "Uppgifterna redovisas uppdelat på den region personen var bosatt i vid diagnos."
      ),
      collapse = "\n<p></p>\n"
    )
  )
}

varOther.nkbcind <- function(x, varbesk = varbesk_other_vars, ...) {
  if (is.null(x$other_vars)) {
    return(NULL)
  } else {
    df <- left_join(tibble(var = x$other_vars), varbesk, by = "var")
    out <- list() # initialisera
    for (i in 1:nrow(df)) {
      out[[i]] <- as.list(df[i, ])
    }
    return(out)
  }
}
