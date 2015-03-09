{-# LANGUAGE OverloadedStrings  #-}

import Blaze.ByteString.Builder
import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Either
import Data.Monoid
import Heist
import Heist.Compiled as C
import Text.Blaze.Html (toHtml)
import Text.Blaze.Html.Renderer.String (renderHtml)
import qualified Data.ByteString as B
import qualified Data.Text as T

escapeHtml :: String -> String
escapeHtml = renderHtml . toHtml

runtime :: RuntimeSplice IO T.Text
runtime = liftIO $ do
  T.pack <$> escapeHtml <$> readFile "src/Main.hs"

splice :: Splice IO
splice = return $ C.yieldRuntimeText $ runtime

main :: IO ()
main = do
  let
    heistConfig = mempty
      {
        hcCompiledSplices = "code-snippet" ## splice,
        hcTemplateLocations = [loadTemplates "."]
      }
  heistState <- either (error "Malformed template?") id <$>
       (runEitherT $ initHeist heistConfig)
  builder <- maybe (error "oops") fst $
       renderTemplate heistState "templates/index"

  let html = toByteString builder
  B.writeFile "static/index.html" html
  putStrLn "Done"

