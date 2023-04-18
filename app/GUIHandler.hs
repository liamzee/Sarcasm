{-# LANGUAGE LambdaCase, OverloadedRecordDot, OverloadedStrings #-}

module GUIHandler where

import Monomer
import InitAndConfig (config)
import Data.Text (Text, pack)
import System.Process
import System.Exit

data GlobalState
    = MkGlobalState
    { consoleLog    :: Text
    , currentScreen :: ScreenState
    , ghcupConfig   :: [Defaults]
    }
    deriving Eq

initialGlobalState = MkGlobalState "" InitialScreenState []

data ScreenState = InitialScreenState | AlternateScreenState
    deriving Eq

data Defaults
    deriving Eq

data Events
    = InitWindow
    | ReturnToDefaultScreen
    | GetConsole
    | GHCupList
    | UpdateConsoleLog Text
    | Exit

openGUI :: IO ()
openGUI =
    startApp
      initialGlobalState
      eventHandler
      initialUI
      config

eventHandler
  :: WidgetEnv GlobalState Events
  -> WidgetNode GlobalState Events
  -> GlobalState
  -> Events
  -> [AppEventResponse GlobalState Events]
eventHandler wenv node model = \case
    ReturnToDefaultScreen ->
        [Model model {currentScreen = AlternateScreenState}]
    New                   ->
        [Model model {currentScreen = InitialScreenState  }]
    GHCupList             ->
        [Task  runGHCupList]
    UpdateConsoleLog text ->
        [Model model {consoleLog = text}]
    Exit                  ->
        [exitApplication]

initialUI
  :: WidgetEnv GlobalState Events
  -> GlobalState
  -> WidgetNode GlobalState Events
initialUI went model = case model.currentScreen of
    InitialScreenState   ->
        hstack
            [ label "Hello, World!"
            , button "Ridiculous" ReturnToDefaultScreen
            , button "Run ghcup List" GHCupList
            ]
    AlternateScreenState ->
        vstack
            [ label "Goobye, Cruel World!"
            , button "Whoops" GetConsole
            , button "Exit"   Exit
            , label_ model.consoleLog [multiline]
            ]

runGHCupList :: IO Events
runGHCupList = do
    output <- readCreateProcess (shell "ghcup list") "list"
    pure . UpdateConsoleLog $ pack output