{-# LANGUAGE OverloadedStrings #-}

module ModelTypes where

import Data.Text (Text)
import Data.Vector (Vector)
import qualified Data.Vector as Vec
import GHCupListTypes (GHCupListLine)

-- | What it says on the barrel:
-- store of global state for Elm Architecture
-- IO framework.

data Model
    = MkModel
    { consoleLog     :: Text
    , currentScreen  :: ScreenState
    , ghcupConfig    :: [Defaults]
    , requestText    :: Text
    , ghcupLibraries :: Vector GHCupListLine
    }
    deriving Eq

-- | Default global state.

initialGlobalState :: Model
initialGlobalState = MkModel "" SelectorScreen [] "" Vec.empty

data ScreenState
    = SelectorScreen -- Introduction screen.
    | LinksScreen    -- Shows links.
    | GHCupScreen    -- Self-explanatory.
    | CabalScreen    -- As above.
    | StackScreen    -- Far from being implemented.
    deriving Eq

data Defaults
    deriving Eq