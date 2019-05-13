library(hexSticker)
library(showtext)
font_add_google("Reenie Beanie", "reenie")
showtext_auto()
hexSticker::sticker("the_thinker.png",
                    package = "fRanz",
                    p_color = "black", 
                    h_fill = "#ABA63E",
                    p_family = "reenie",
                    filename = "fRanz.png")