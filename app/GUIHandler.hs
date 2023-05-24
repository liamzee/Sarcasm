{-# LANGUAGE LambdaCase, OverloadedRecordDot, OverloadedStrings #-}

module GUIHandler (openGUI) where

import Monomer ( startApp, WidgetEnv, WidgetNode )
import InitAndConfig (config)
import ModelTypes
    ( initialGlobalState,
      Model(currentScreen),
      ScreenState(GHCupScreen, SelectorScreen) )
import SelectorScreen (selectorScreen)
import EventHandler (eventHandler)
import GHCupScreen (ghcUpScreen)
import EventTypes (Events)

-- | Actually running the monomer GUI generator.

openGUI :: IO ()
openGUI =
    startApp
      initialGlobalState
      eventHandler
      (flip uiSplitter)
      config

uiSplitter
  :: Model
  -> WidgetEnv Model Events
  -> WidgetNode Model Events
uiSplitter state = case state.currentScreen of
    SelectorScreen -> flip selectorScreen state
    GHCupScreen    -> flip ghcUpScreen state
