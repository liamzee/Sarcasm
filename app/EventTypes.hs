module EventTypes where
import Data.Text (Text)

-- | Events for the global event handler.

data Events
    = InitWindow
    | ShowGHCupScreen
    | ReturnToDefaultScreen
    | GetConsole
    | GHCupCommand GHCupCommands
    | UpdateConsoleLog Text
    | Exit

data GHCupCommands
    = Install -- Install an element.
    | Remove  -- Remove an element.
    | Set     -- Set an element as active.
    | Unset   -- Unset an element as active.
    | Upgrade -- Upgrade GHCup.
    | List    -- List GHCup elements.
    | Nuke    -- Remove GHCup from the system.