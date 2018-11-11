-- NOTE REGARDING ROOM TEMPLATES AND EDITING CURRENT TILESETS --

DO NOT ATTEMPT TO MAKE FINALIZED/POLISHED ROOM TEMPLATES

This is because if we decide to later change a tilesheet that is being used, it will fuck up the entire room template causing a massive loss of data.  The way to avoid something like this from happening, is only making permanent room templates ONCE the tilesets are FINIALIZED!!!

To finialize a tileset we must prune through the r4407 goon images and make sure they are not apart of current images.  Then we need to remove any images that are not needed.  (ie. unwanted sprites in a tilesheet)  Once this is done, the spritesheet can be used BUT UNDER THE CONDITION THAT IT CAN NEVER BE EDITED ONCE IN USE!  This essentially locks it in place.

So again step-by-step:
  1.  Compare spritesheet to make sure it's a /tg/ sprite and not a goon code sprite from the initial release
  2.  Prune sprites we do not want to use
  3.  Put in correct directory for ZomboTropolis
  4.  Success!