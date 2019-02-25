varbesk_other_vars <- tibble::enframe(
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
