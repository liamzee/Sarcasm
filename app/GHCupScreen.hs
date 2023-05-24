{-# LANGUAGE OverloadedStrings, OverloadedRecordDot #-}

module GHCupScreen where

import ModelTypes (Model (..))
import EventTypes (Events (..), GHCupCommands (List, Upgrade))
import Monomer
    ( label,
      UIBuilder,
      styleBasic,
      textSize,
      textColor,
      red,
      WidgetNode,
      onClick )
import Monomer.Widgets.Containers.Box (box_)
import Monomer.Widgets ( spacer, hgrid, textAreaV )
import Monomer.Widgets.Container ( alignCenter, alignMiddle )
import Monomer.Graphics.ColorTable (black)

ghcUpScreen :: UIBuilder Model Events
ghcUpScreen wenv state =
    hgrid
        [ console
        , ghcupListButton
        , ghcupUpgradeButton
        ]
  where
    console :: WidgetNode Model Events
    console =
        box_ [alignCenter, alignMiddle]
            $ textAreaV state.consoleLog UpdateConsoleLog

ghcupListButton :: WidgetNode Model Events
ghcupListButton =
    box_ [alignCenter, alignMiddle, onClick $ GHCupCommand List]
        $ label "get GHCList output" `styleBasic` [textSize 24, textColor red]

ghcupUpgradeButton :: WidgetNode Model Events
ghcupUpgradeButton =
    box_ [alignCenter, alignMiddle, onClick $ GHCupCommand Upgrade]
        $ label "yes? this should do something?" `styleBasic` [textSize 24, textColor black]