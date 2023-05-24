{-# LANGUAGE OverloadedStrings, OverloadedRecordDot #-}

module InitAndConfig (initialize, config) where

import Monomer
import System.Directory
import Control.Monad (unless)
import Network.HTTP.Simple
import qualified Data.ByteString.Char8 as BS8
import Data.Foldable (for_)
import EventTypes ( Events )

-- | initialize is currently checkAssets only.
-- Perhaps it might make more sense
-- to move GUI init to initialize; i.e, get the first
-- data set from GHCup before monomer runs?

initialize :: IO ()
initialize = do
    checkAssets assetsList

-- | Storing config next to checkAssets
-- so that it's obvious which assets are needed.

config :: [AppConfig Events]
config = 
    [ appWindowTitle "Sarcasm GHCup Wrapper"
    , appWindowState  $ MainWindowNormal (1024, 600)
    , appWindowIcon  "./assets/images/icon.bmp"
    , appTheme        haskellTheme
    , appFontDef     "Regular"
                     "./assets/fonts/Roboto-Regular.ttf"
    ]

haskellTheme :: Theme
haskellTheme = darkTheme
    { _themeClearColor   = white
    , _themeSectionColor = gray
    }

type Asset = (FilePath, RemoteLocation)
type RemoteLocation = String

-- | List of assets. Might be worthwhile to invoke
-- unsafePerformIO to support a Windows split
-- on icon.bmp, since at the present, monomer is not
-- supporting png icons for some reason.

assetsList :: [Asset]
assetsList =
    [ appIcon
    , robotoRegular
    ]
  where
    appIcon =
        ( "assets/images/icon.bmp"
        , "https://raw.githubusercontent.com/ngemily/sample-bmp-tb/master/imgs/balloon.bmp"
        )
    robotoRegular =
        ( "assets/fonts/Roboto-Regular.ttf"
        , "https://github.com/googlefonts/roboto/raw/main/src/hinted/Roboto-Regular.ttf"
        )

-- | Perhaps this might be cleaner in do notation? Sends to getAsset
-- in order to actually draw assets. Could be condensed simply by going
-- to for_, but might be more readable this way.

checkAssets :: [Asset] -> IO ()
checkAssets listOfAssets = for_ listOfAssets checkForAsset
  where
    checkForAsset (localLocale, remoteLocation) =
        doesFileExist localLocale >>=
            flip unless (getAsset localLocale $ parseRequest_ remoteLocation)

-- | Actually get the asset from web, check if the directory is missing, then
-- use the Bytestring IO utility to actually create the target.
-- Right now, unfortunately, this code does not work if some kind of
-- access error is created, however.

getAsset :: FilePath -> Request -> IO ()
getAsset fp req = do
    body <- httpBS req
    createDirectoryIfMissing True parsedFilePath
    let output = getResponseBody body
    BS8.writeFile fp output
  where
    parsedFilePath = reverse . dropWhile (/= '/') $ reverse fp 
