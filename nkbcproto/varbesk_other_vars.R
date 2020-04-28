varbesk_other_vars <- nkbcind::varbesk_other_vars %>%
  bind_rows(
    tibble::enframe(
      c(
        d_mstad = "Fjärrmetastaser vid diagnos"
      ),
      name = "var",
      value = "label"
    )
  )
