module Main where

import InitAndConfig (initialize)
import GUIHandler (openGUI)

main :: IO ()
main = do
    initialize
    openGUI
