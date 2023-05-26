{-# LANGUAGE OverloadedStrings #-}

module SelectorScreen where
import Monomer
    ( UIBuilder, spacer, CmbOnClick(onClick), WidgetNode )
import ModelTypes (Model)
import EventTypes (Events (ShowGHCupScreen))
import Monomer.Widgets (box_, hgrid)
import Monomer.Widgets.Container (alignCenter)
import Monomer.Widgets.Singles.Image (image_)

selectorScreen :: UIBuilder Model Events
selectorScreen wenv state = hgrid
    [ spacer
    , ghcupButton
    , spacer
    ]

ghcupButton :: WidgetNode Model Events
ghcupButton = box_ [onClick ShowGHCupScreen, alignCenter] buttonGraphics
  where
    buttonGraphics = image_ "https://www.haskell.org/ghcup/haskell_logo.png" [alignCenter]