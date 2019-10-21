mutate_nkbc_d_vars <- function(x, ...) {
  mutate(x,
    # Beräkna variabel för primär behandling
    d_prim_beh_Varde = coalesce(op_kir_Varde, a_planbeh_typ_Varde),

    # Beräkna variabel för invasiv cancer
    d_invasiv_Varde = case_when(
      a_pad_invasiv_Varde %in% 1 | op_pad_invasiv_Varde %in% 1 ~ 1L,
      a_pad_invasiv_Varde %in% 2 | op_pad_invasiv_Varde %in% 2 ~ 2L,
      TRUE ~ NA_integer_
    ),

    # ER, 1 = pos, 2 = neg
    d_er_op_Varde = case_when(
      op_pad_erproc < 10 | is.na(op_pad_erproc) & op_pad_er_Varde %in% 2 ~ 2L,
      op_pad_erproc >= 10 | is.na(op_pad_erproc) & op_pad_er_Varde %in% 1 ~ 1L
    ),

    d_er_a_Varde = case_when(
      a_pad_erproc < 10 | is.na(a_pad_erproc) & a_pad_er_Varde %in% 2 ~ 2L,
      a_pad_erproc >= 10 | is.na(a_pad_erproc) & a_pad_er_Varde %in% 1 ~ 1L
    ),

    d_er_Varde = case_when(
      d_prim_beh_Varde == 1 ~ d_er_op_Varde,
      d_prim_beh_Varde %in% c(2, 3) ~ d_er_a_Varde,
      TRUE ~ NA_integer_
    ),

    # PR, 1 = pos, 2 = neg
    d_pr_op_Varde = case_when(
      op_pad_prproc < 10 | is.na(op_pad_prproc) & op_pad_pr_Varde %in% 2 ~ 2L,
      op_pad_prproc >= 10 | is.na(op_pad_prproc) & op_pad_pr_Varde %in% 1 ~ 1L
    ),

    d_pr_a_Varde = case_when(
      a_pad_prproc < 10 | is.na(a_pad_prproc) & a_pad_pr_Varde %in% 2 ~ 2L,
      a_pad_prproc >= 10 | is.na(a_pad_prproc) & a_pad_pr_Varde %in% 1 ~ 1L
    ),

    d_pr_Varde = case_when(
      d_prim_beh_Varde == 1 ~ d_pr_op_Varde,
      d_prim_beh_Varde %in% c(2, 3) ~ d_pr_a_Varde,
      TRUE ~ NA_integer_
    ),

    # HER2, 1 = pos, 2 = neg
    d_her2_op_Varde = case_when(
      op_pad_her2_Varde %in% 3 | op_pad_her2ish_Varde %in% 1 ~ 1L,
      op_pad_her2_Varde %in% c(1, 2) | op_pad_her2ish_Varde %in% 2 ~ 2L
    ),

    d_her2_a_Varde = case_when(
      a_pad_her2_Varde %in% 3 | a_pad_her2ish_Varde %in% 1 ~ 1L,
      a_pad_her2_Varde %in% c(1, 2) | a_pad_her2ish_Varde %in% 2 ~ 2L
    ),

    d_her2_Varde = case_when(
      d_prim_beh_Varde == 1 ~ d_her2_op_Varde,
      d_prim_beh_Varde %in% c(2, 3) ~ d_her2_a_Varde,
      TRUE ~ NA_integer_
    ),

    # Biologisk subtyp, 1 = Luminal, 2 = HER2, 3 = TNBC, 99 = Uppgift saknas
    d_trigrp_Varde = case_when(
      d_er_Varde %in% 2 & d_pr_Varde %in% 2 & d_her2_Varde %in% 2 ~ 3L,
      is.na(d_er_Varde) | is.na(d_pr_Varde) | is.na(d_her2_Varde) ~ 99L,
      d_her2_Varde %in% 1 ~ 2L,
      d_er_Varde %in% 1 | d_pr_Varde %in% 1 ~ 1L,
      TRUE ~ 99L
    ),

    # fix 1.sjukhus ansvarigt för rapportering av onkologisk behandling/2.onkologiskt sjukhus/3.anmälande sjukhus
    d_onkpostans_sjhkod = coalesce(
      post_inr_sjhkod,
      op_onk_sjhkod,
      a_onk_rappsjhkod,
      a_onk_sjhkod,
      a_inr_sjhkod
    ),
    d_onkpreans_sjhkod = coalesce(
      pre_inr_sjhkod,
      op_onk_sjhkod,
      a_onk_rappsjhkod,
      a_onk_sjhkod,
      a_inr_sjhkod
    ),
    # fix 1) post onk sjukhus 2) pre onk sjukhus
    d_onk_sjhkod = coalesce(
      post_inr_sjhkod,
      pre_inr_sjhkod
    ),
    # Sjukhus ansvarig för primär behandling
    d_prim_beh_sjhkod = case_when(
      d_prim_beh_Varde == 1 ~ op_inr_sjhkod,
      d_prim_beh_Varde == 2 ~ pre_inr_sjhkod,
      TRUE ~ NA_integer_
    ),

    # LKF-region för att imputera om region för sjukhus saknas
    d_region_lkf = case_when(
      REGION_NAMN == "Region Sthlm/Gotland" ~ 1L,
      REGION_NAMN == "Region Uppsala/Örebro" ~ 2L,
      REGION_NAMN == "Region Sydöstra" ~ 3L,
      REGION_NAMN == "Region Syd" ~ 4L,
      REGION_NAMN == "Region Väst" ~ 5L,
      REGION_NAMN == "Region Norr" ~ 6L,
      TRUE ~ NA_integer_
    )
  )
}
