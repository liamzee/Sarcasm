{-# LANGUAGE OverloadedStrings #-}

module InitAndConfig where

import Monomer
import System.Directory
import Control.Monad (unless)
import Network.HTTP.Simple
import qualified Data.ByteString.Char8 as BS8
import Data.Foldable (for_)

initialize :: IO ()
initialize = do
    checkAssets assetsList

config :: [AppConfig typeInferred]
config = 
    [ appWindowTitle "Sarcasm GHCup Wrapper"
    , appWindowState $ MainWindowMaximized
    , appWindowIcon  "./assets/images/icon.bmp"
    , appTheme        lightTheme
    , appFontDef     "Regular"
                     "./assets/fonts/Roboto-Regular.ttf"
    ]

type Asset = (FilePath, RemoteLocation)
type RemoteLocation = String

assetsList :: [Asset]
assetsList =
    [ icon
    , robotoRegular
    ]
  where
    icon =
        ( "assets\\images\\icon.bmp"
        , "https://raw.githubusercontent.com/ngemily/sample-bmp-tb/master/imgs/balloon.bmp"
        )
    robotoRegular =
        ( "assets\\fonts\\Roboto-Regular.ttf"
        , "https://github.com/googlefonts/roboto/raw/main/src/hinted/Roboto-Regular.ttf"
        )

checkAssets :: [Asset] -> IO ()
checkAssets listOfAssets = for_ listOfAssets checkForAsset
  where
    checkForAsset (localLocale, remoteLocation) =
        doesFileExist localLocale >>=
            flip unless (getAsset localLocale $ parseRequest_ remoteLocation)

getAsset :: FilePath -> Request -> IO ()
getAsset fp req = do
    body <- httpBS req
    createDirectoryIfMissing True parsedFilePath
    let output = getResponseBody body
    BS8.writeFile fp output
  where
    parsedFilePath = reverse . dropWhile (/= '\\') $ reverse fp 