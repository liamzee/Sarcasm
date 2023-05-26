{-# LANGUAGE LambdaCase, OverloadedStrings, ViewPatterns #-}

module EventHandler where
import ModelTypes (Model (currentScreen, consoleLog, requestText), ScreenState (GHCupScreen))
import Monomer.Core.WidgetTypes (WidgetNode)
import Monomer.Main.Core (AppEventResponse)
import Monomer.Widgets (WidgetEnv)
import Monomer.Widgets.Composite (EventResponse(Model))
import Monomer (EventResponse(Task))
import System.Process (shell, readCreateProcessWithExitCode)
import Data.Text (pack, Text, unpack)
import EventTypes
    ( Events(ShowGHCupScreen, UpdateConsoleLog, GHCupCommand, UpdateRequestText),
      GHCupCommands(List, Upgrade),
      GHCupCommands(GHCupRequest) )

eventHandler
  :: WidgetEnv Model Events
  -> WidgetNode Model Events
  -> Model
  -> Events
  -> [AppEventResponse Model Events]
eventHandler wenv node model = \case
    ShowGHCupScreen            -> [Model model {currentScreen = GHCupScreen}]
    UpdateConsoleLog text      -> [Model model {consoleLog = text}]
    GHCupCommand command       -> [Task $ doCommand command] 
    UpdateRequestText text     -> [Model model {requestText = text}]


doCommand :: GHCupCommands -> IO Events
doCommand input = do
    (u, stdout, stderr) <- readCreateProcessWithExitCode (shell $ "ghcup " <> command) ""
    pure . UpdateConsoleLog . pack $ (show u) <> stderr <> stdout
  where
    command = unpack $ case input of
      List -> "list"
      Upgrade -> "upgrade"
      GHCupRequest txt -> txt