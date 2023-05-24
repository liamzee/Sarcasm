module Main where

import InitAndConfig (initialize)
import GUIHandler (openGUI)

-- | Aiming for a clean main.
-- Initialize will attempt to ensure that the assets that
-- monomer requires will actually be available,
-- while openGUI actually runs the monomer framework.

main :: IO ()
main = do
    initialize
    openGUI

--