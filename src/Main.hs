{-# LANGUAGE OverloadedStrings  #-}

import Blaze.ByteString.Builder
import Control.Applicative
import Control.Monad
import Control.Monad.Trans.Either
import Data.Monoid
import Heist
import Heist.Compiled as C
import Text.Blaze.Html (toHtml)
import Text.Blaze.Html.Renderer.String (renderHtml)
import qualified Data.ByteString as B

escapeHtml :: String -> String
escapeHtml = renderHtml . toHtml

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
  putStrLn $ escapeHtml "<em>HELLO</em>"
