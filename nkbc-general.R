add_sjhdata <- function(x, sjukhuskoder = sjukhuskoder, sjhkod_var = GLOBALS$SJHKODUSE) {
  names(x)[names(x) == sjhkod_var] <- "sjhkod"

  x %>%
    mutate(sjhkod = as.numeric(sjhkod)) %>%
    left_join(sjukhuskoder, by = c("sjhkod" = "sjukhuskod")) %>%
    mutate(
      region = case_when(
        region_sjh_txt == "Sthlm/Gotland" ~ 1L,
        region_sjh_txt == "Uppsala/Örebro" ~ 2L,
        region_sjh_txt == "Sydöstra" ~ 3L,
        region_sjh_txt == "Syd" ~ 4L,
        region_sjh_txt == "Väst" ~ 5L,
        region_sjh_txt == "Norr" ~ 6L,
        TRUE ~ NA_integer_
      ),
      region = ifelse(is.na(region), region_lkf, region),
      landsting = substr(sjhkod, 1, 2) %>% as.integer(),
      # Fulfix Bröstmottagningen, Christinakliniken Sh & Stockholms bröstklinik så hamnar i Stockholm
      landsting = ifelse(sjhkod %in% c(97333, 97563), 10, landsting),
      landsting = ifelse(
        landsting %in% c(
          seq(10, 13),
          seq(21, 28),
          30,
          seq(41, 42),
          seq(50, 57),
          seq(61, 65)
          # seq(91,96)
        ),
        landsting,
        NA
      )
    )
}

derive_nkbc_d_vars <- function(x, ...) {
  x %>%
    mutate(
      # Beräkna variabel för primär behandling
      d_prim_beh_Värde = coalesce(op_kir_Värde, a_planbeh_typ_Värde),

      # Beräkna variabel för invasiv cancer
      d_invasiv_Värde = ifelse(d_prim_beh_Värde == 1, op_pad_invasiv_Värde,
        ifelse(d_prim_beh_Värde %in% c(2, 3) | is.na(d_prim_beh_Värde), a_pad_invasiv_Värde,
          NA
        )
      ),

      d_invasiv_Värde = ifelse(d_invasiv_Värde == 98, NA, d_invasiv_Värde), ## added 2017-11-09
      d_invasiv = factor(d_invasiv_Värde, c(1, 2, NA),
        c("Invasiv cancer", "Enbart cancer in situ", "Uppgift saknas"),
        exclude = NULL
      ),

      # ER, 1 = pos, 2 = neg
      d_er_op_Värde = case_when(
        op_pad_erproc < 10 | is.na(op_pad_erproc) & op_pad_er_Värde %in% 2 ~ 2,
        op_pad_erproc >= 10 | is.na(op_pad_erproc) & op_pad_er_Värde %in% 1 ~ 1
      ),

      d_er_a_Värde = case_when(
        a_pad_erproc < 10 | is.na(a_pad_erproc) & a_pad_er_Värde %in% 2 ~ 2,
        a_pad_erproc >= 10 | is.na(a_pad_erproc) & a_pad_er_Värde %in% 1 ~ 1
      ),

      d_er_Värde = ifelse(d_prim_beh_Värde == 1, d_er_op_Värde,
        ifelse(d_prim_beh_Värde %in% c(2, 3), d_er_a_Värde,
          NA
        )
      ),

      # PR, 1 = pos, 2 = neg
      d_pr_op_Värde = case_when(
        op_pad_prproc < 10 | is.na(op_pad_prproc) & op_pad_pr_Värde %in% 2 ~ 2,
        op_pad_prproc >= 10 | is.na(op_pad_prproc) & op_pad_pr_Värde %in% 1 ~ 1
      ),

      d_pr_a_Värde = case_when(
        a_pad_prproc < 10 | is.na(a_pad_prproc) & a_pad_pr_Värde %in% 2 ~ 2,
        a_pad_prproc >= 10 | is.na(a_pad_prproc) & a_pad_pr_Värde %in% 1 ~ 1
      ),

      d_pr_Värde = ifelse(d_prim_beh_Värde == 1, d_pr_op_Värde,
        ifelse(d_prim_beh_Värde %in% c(2, 3), d_pr_a_Värde,
          NA
        )
      ),

      # HER2, 1 = pos, 2 = neg
      d_her2_op_Värde = case_when(
        op_pad_her2_Värde %in% 3 | op_pad_her2ish_Värde %in% 1 ~ 1,
        op_pad_her2_Värde %in% c(1, 2) | op_pad_her2ish_Värde %in% 2 ~ 2
      ),

      d_her2_a_Värde = case_when(
        a_pad_her2_Värde %in% 3 | a_pad_her2ish_Värde %in% 1 ~ 1,
        a_pad_her2_Värde %in% c(1, 2) | a_pad_her2ish_Värde %in% 2 ~ 2
      ),

      d_her2_Värde = ifelse(d_prim_beh_Värde == 1, d_her2_op_Värde,
        ifelse(d_prim_beh_Värde %in% c(2, 3), d_her2_a_Värde,
          NA
        )
      ),

      d_subtyp = factor(case_when(
        d_er_Värde %in% 2 & d_pr_Värde %in% 2 & d_her2_Värde %in% 2 ~ 1,
        is.na(d_er_Värde) | is.na(d_pr_Värde) | is.na(d_her2_Värde) ~ 99,
        d_her2_Värde %in% 1 ~ 2,
        d_er_Värde %in% 1 | d_pr_Värde %in% 1 ~ 3,
        TRUE ~ 99
      ),
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

      # fix 1.sjukhus ansvarigt för rapportering av onkologisk behandling/2.onkologiskt sjukhus/3.anmälande sjukhus
      d_onkpostans_sjhkod = coalesce(
        as.numeric(post_inr_sjhkod),
        as.numeric(op_onk_sjhkod),
        as.numeric(a_onk_rappsjhkod),
        as.numeric(a_onk_sjhkod),
        as.numeric(a_inr_sjhkod)
      ),
      d_onkpreans_sjhkod = coalesce(
        as.numeric(pre_inr_sjhkod),
        as.numeric(op_onk_sjhkod),
        as.numeric(a_onk_rappsjhkod),
        as.numeric(a_onk_sjhkod),
        as.numeric(a_inr_sjhkod)
      ),
      # fix 1) post onk sjukhus 2) pre onk sjukhus
      d_onk_sjhkod = coalesce(
        as.numeric(post_inr_sjhkod),
        as.numeric(pre_inr_sjhkod)
      )
    )
}
