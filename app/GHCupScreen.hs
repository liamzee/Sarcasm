{-# LANGUAGE OverloadedStrings, OverloadedRecordDot #-}

module GHCupScreen where

import ModelTypes (Model (..))
import EventTypes
    ( Events(..),
      GHCupCommands(List, Upgrade),
      GHCupCommands(GHCupRequest) )
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
import Monomer.Widgets ( hgrid, textAreaV, button )
import Monomer.Widgets.Container ( alignCenter, alignMiddle )
import Monomer.Graphics.ColorTable (black)
import Monomer.Widgets.Containers.Grid (vgrid)
import Monomer.Widgets.Singles.TextField (textFieldV)

ghcUpScreen :: UIBuilder Model Events
ghcUpScreen wenv state =
    hgrid
        [ console
        , ghcupListButton
        , requestInputter
        ]
  where
    console :: WidgetNode Model Events
    console =
        box_ [alignCenter, alignMiddle]
            $ textAreaV state.consoleLog UpdateConsoleLog

    requestInputter :: WidgetNode Model Events
    requestInputter = vgrid [ box_ [alignCenter, alignMiddle] $ textFieldV state.requestText UpdateRequestText
                            , button "make request" . GHCupCommand $ GHCupRequest state.requestText]

ghcupListButton :: WidgetNode Model Events
ghcupListButton =
    box_ [alignCenter, alignMiddle, onClick $ GHCupCommand List]
        $ label "get GHCList output" `styleBasic` [textSize 24, textColor red]

ghcupUpgradeButton :: WidgetNode Model Events
ghcupUpgradeButton =
    box_ [alignCenter, alignMiddle, onClick $ GHCupCommand Upgrade]
        $ label "yes? this should do something?" `styleBasic` [textSize 24, textColor black]