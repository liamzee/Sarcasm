{-# LANGUAGE LambdaCase, OverloadedStrings #-}

module EventHandler where
import ModelTypes (Model (currentScreen, consoleLog), ScreenState (GHCupScreen))
import Monomer.Core.WidgetTypes (WidgetNode)
import Monomer.Main.Core (AppEventResponse)
import Monomer.Widgets (WidgetEnv)
import Monomer.Widgets.Composite (EventResponse(Model))
import Monomer (EventResponse(Task))
import System.Process (readCreateProcess, shell)
import Data.Text (pack)
import EventTypes (Events (ShowGHCupScreen, UpdateConsoleLog, GHCupCommand), GHCupCommands (List, Upgrade))

eventHandler
  :: WidgetEnv Model Events
  -> WidgetNode Model Events
  -> Model
  -> Events
  -> [AppEventResponse Model Events]
eventHandler wenv node model = \case
    ShowGHCupScreen -> [Model model {currentScreen = GHCupScreen}]
    UpdateConsoleLog text -> [Model model {consoleLog = text}]
    GHCupCommand List -> [Task runGHCupList]
    GHCupCommand Upgrade -> [Task doGHCupUpgrade]

  
runGHCupList :: IO Events
runGHCupList = do
    output <- readCreateProcess (shell "ghcup list") "list"
    writeFile "store" output
    pure . UpdateConsoleLog $ pack output


doGHCupUpgrade :: IO Events
doGHCupUpgrade = do
    output <- readCreateProcess (shell "ghcup upgrade") "upgrade"
    writeFile "store" output
    pure . UpdateConsoleLog $ pack output