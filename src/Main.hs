{-# LANGUAGE OverloadedStrings  #-}

import Blaze.ByteString.Builder
import Control.Applicative
import Control.Monad
import Control.Monad.Trans.Either
import Data.Monoid
import Heist
import Heist.Compiled as C
import Text.XML
import qualified Data.ByteString as B

splice :: Splice IO
splice = C.runChildren

main :: IO ()
main = do
  let
    heistConfig = mempty
      {
        hcCompiledSplices = "foo" ## splice,
        hcTemplateLocations = [loadTemplates "."]
      }
  heistState <- either (error "oops") id <$>
       (runEitherT $ initHeist heistConfig)
  builder <- maybe (error "oops") fst $
       renderTemplate heistState "templates/index"

  let html = toByteString builder
  B.writeFile "static/index.html" html
  putStrLn encodeHtml '<em>HELLO</em>'
