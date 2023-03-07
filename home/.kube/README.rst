##############
OpenLens icons
##############

Because OpenLens lets you pick an icon for each cluster,
which makes it more difficult than just using plain text.
- But admittedly prettier.

-------

CXREF:

  https://imagemagick.org/script/color.php

  https://legacy.imagemagick.org/Usage/text/#label

-------

This centers it... and is 1st of at least 4 icons I need at my latest
gig, where I've got a local cluster and access to three more::

  convert -size 64x64 xc:none +size \
    \( -background fractal \
      -size 64x60 \
      -fill wheat2 \
      -font /System/Library/Fonts/Supplemental/DIN\ Condensed\ Bold.ttf \
      -gravity center \
      "label: disp\n-dev" \
      -append \) \
    -gravity South -crop 0x64+0+0 +append \
        -bordercolor none -border 1 -trim \
        +repage -background white -flatten \
    openlens-icon_disp-dev.png

  open openlens-icon_disp-dev.png

Another one::

  convert -size 64x64 xc:none +size \
    \( -background tomato \
      -size 64x60 \
      -fill black \
      -font /System/Library/Fonts/Supplemental/Impact.ttf \
      -gravity center \
      "label: disp\n-prod" \
      -append \) \
    -gravity South -crop 0x64+0+0 +append \
        -bordercolor none -border 1 -trim \
        +repage -background white -flatten \
    openlens-icon_disp-prod.png

  open openlens-icon_disp-prod.png

A Third::

  convert -size 64x64 xc:none +size \
    \( -background peru \
      -size 64x60 \
      -fill SteelBlue4 \
      -font /System/Library/Fonts/Supplemental/Phosphate.ttc \
      -gravity center \
      "label: DEV" \
      -append \) \
    -gravity South -crop 0x64+0+0 +append \
        -bordercolor none -border 1 -trim \
        +repage -background white -flatten \
    openlens-icon_dev.png

  open openlens-icon_dev.png

The Fourth::

  convert -size 64x64 xc:none +size \
    \( -background lightblue \
      -size 64x60 \
      -fill blue \
      -font /System/Library/Fonts/Supplemental/SignPainter.ttc \
      -gravity center \
      "label: LO-\nCAL" \
      -append \) \
    -gravity South -crop 0x64+0+0 +append \
        -bordercolor none -border 1 -trim \
        +repage -background white -flatten \
    openlens-icon_local.png

  open openlens-icon_local.png

-------

