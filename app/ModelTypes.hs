{-# LANGUAGE OverloadedStrings #-}

module ModelTypes where

import Data.Text (Text)

-- | What it says on the barrel:
-- store of global state for Elm Architecture
-- IO framework.

data Model
    = MkModel
    { consoleLog    :: Text
    , currentScreen :: ScreenState
    , ghcupConfig   :: [Defaults]
    }
    deriving Eq

-- | Default global state.

initialGlobalState :: Model
initialGlobalState = MkModel "" SelectorScreen []

data ScreenState = SelectorScreen | GHCupScreen
    deriving Eq

data Defaults
    deriving Eq