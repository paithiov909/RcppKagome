try(detach("package:RcppKagome", unload = TRUE))
usethis::use_tidy_style()
pkgdown::build_site()
