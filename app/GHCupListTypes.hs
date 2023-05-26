module GHCupListTypes where

import Data.Vector (Vector)

data GHCupListLine = MkGHCupListLine GHCupToolSet GHCupToolName GHCupToolVersion (Vector GHCupToolTags) (Vector GHCupToolNotes)
    deriving Eq

data GHCupToolSet
    = MkGHCupToolSet
    { toolIsSet       :: Bool
    , toolIsInstalled :: Bool
    } deriving Eq

data GHCupToolName = ToolGHC | ToolGHCup | ToolCabalTool | ToolHLS | ToolStack
    deriving Eq

data GHCupToolVersion = MkGHCupToolVersion Int Int Int (Maybe Int)
    deriving Eq

data GHCupToolTags = Latest | Recommended | BaseVersion Int Int Int Int
    deriving Eq

data GHCupToolNotes = HLSPowered
    deriving Eq