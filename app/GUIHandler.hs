{-# LANGUAGE OverloadedRecordDot, OverloadedStrings #-}

module GUIHandler ((🧁)) where

import Monomer ( startApp, WidgetEnv, WidgetNode )
import InitAndConfig (config)
import ModelTypes
    ( initialGlobalState,
      Model(currentScreen),
      ScreenState(..) )
import SelectorScreen (selectorScreen)
import EventHandler (eventHandler)
import GHCupScreen (ghcUpScreen)
import EventTypes (Events)

-- | Actually running the monomer GUI generator.

(🧁) :: IO ()
(🧁) =
    startApp
      initialGlobalState
      eventHandler
      (flip uiSplitter)
      config

uiSplitter
  :: Model
  -> WidgetEnv Model Events
  -> WidgetNode Model Events
uiSplitter model = (`displayedScreen` model)
  where
    displayedScreen = case model.currentScreen of
      SelectorScreen -> selectorScreen
      LinksScreen    -> error "not yet implemented"
      GHCupScreen    -> ghcUpScreen
      CabalScreen    -> error "not yet implemented"
      StackScreen    -> error "not yet implemented"