mutate_nkbc_other_vars <- function(x, ...) {
  mutate(x,

    # Invasivitet
    d_invasiv = factor(
      replace_na(d_invasiv_Värde, 99),
      levels = c(1, 2, 99),
      labels = c("Invasiv cancer", "Enbart cancer in situ", "Uppgift saknas")
    ),

    # ER
    d_er = factor(
      replace_na(d_er_Värde, 99),
      levels = c(1, 2, 99),
      labels = c("Positiv", "Negativ", "Uppgift saknas")
    ),

    # Biologisk subtyp
    d_subtyp = factor(
      d_subtyp_Värde,
      levels = c(3, 2, 1, 99),
      labels = c("Trippel negativ", "HER2 positiv", "Luminal", "Uppgift saknas")
    ),

    # T
    d_tstad = factor(
      case_when(
        a_tnm_tklass_Värde == 0 ~ 1,
        a_tnm_tklass_Värde == 5 ~ 1,
        a_tnm_tklass_Värde == 10 ~ 1,
        a_tnm_tklass_Värde == 20 ~ 2,
        a_tnm_tklass_Värde == 30 ~ 2,
        a_tnm_tklass_Värde == 42 ~ 2,
        a_tnm_tklass_Värde == 44 ~ 2,
        a_tnm_tklass_Värde == 45 ~ 2,
        a_tnm_tklass_Värde == 46 ~ 2,
        a_tnm_tklass_Värde == 50 ~ 99,
        is.na(a_tnm_tklass_Värde) ~ 99,
        TRUE ~ NA_real_
      ),
      levels = c(1, 2, 99),
      labels = c("<=20mm (T0/T1)", ">20mm (T2-T4)", "Uppgift saknas")
    ),

    # N
    d_nstad = factor(
      case_when(
        a_tnm_nklass_Värde == 0 ~ 1,
        a_tnm_nklass_Värde == 10 ~ 2,
        a_tnm_nklass_Värde == 20 ~ 2,
        a_tnm_nklass_Värde == 30 ~ 2,
        a_tnm_nklass_Värde == 40 ~ 99,
        is.na(a_tnm_nklass_Värde) ~ 99,
        TRUE ~ NA_real_
      ),
      levels = c(1, 2, 99),
      labels = c("Nej (N0)", "Ja (N1-N3)", "Uppgift saknas")
    ),

    # M
    d_mstad = factor(
      case_when(
        a_tnm_mklass_Värde == 0 ~ 1,
        a_tnm_mklass_Värde == 10 ~ 2,
        a_tnm_mklass_Värde == 20 ~ 99,
        is.na(a_tnm_mklass_Värde) ~ 99,
        TRUE ~ NA_real_
      ),
      levels = c(1, 2, 99),
      labels = c("Nej (M0)", "Ja (M1)", "Uppgift saknas")
    ),

    # pN
    d_pn = cut(op_pad_lglmetant, c(1, 4, 100),
      include.lowest = TRUE,
      right = FALSE,
      labels = c("1-3 metastaser", "=> 4 metastaser")
    ),

    d_pnstat =
      factor(
        case_when(
          op_pad_lglmetant == 0 ~ "Nej (pN-)",
          op_pad_lglmetant > 0 ~ "Ja (pN+)",
          TRUE ~ "Uppgift saknas"
        ),
        levels = c("Nej (pN-)", "Ja (pN+)", "Uppgift saknas")
      ),

    d_max_extent = pmax(op_pad_extentx, op_pad_extenty, na.rm = TRUE),

    d_kemo = as.logical(pmax(post_kemo_Värde, pre_kemo_Värde, na.rm = TRUE))
  )
}
