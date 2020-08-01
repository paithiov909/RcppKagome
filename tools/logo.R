library(usethis)
library(pkgdown)
library(hexSticker)

img <- file.path(getwd(),
    "man",
    "figures",
    "bird.svg"
)

hexSticker::sticker(
    img,
    s_x = 1,
    s_width = .5,
    s_height = .5,
    p_size = 18,
    package = "RcppKagome",
    p_color = "#5268af",
    h_size = 2.4,
    h_fill = "#e6e7e7",
    h_color = "#7090f0",
    filename = "man/figures/logo-origin.png"
)

use_logo("man/figures/logo-origin.png")
build_favicons(overwrite = TRUE)
