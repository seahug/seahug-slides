{-# LANGUAGE OverloadedStrings  #-}

import Blaze.ByteString.Builder
import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Either
import Data.Monoid
import Data.String.Utils as S
import Heist
import Heist.Compiled as C
import Text.Blaze.Html (toHtml)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Printf (printf)
import qualified Text.XmlHtml as X
import qualified Data.ByteString as B
import qualified Data.Text as T

escapeHtml :: String -> String
escapeHtml = renderHtml . toHtml

formatCodeSnippet :: String -> String
formatCodeSnippet = (S.replace " " "&nbsp;") . (S.replace "\n" "<br/>\n") . escapeHtml

codeSnippet :: String -> RuntimeSplice IO T.Text
codeSnippet fileName = liftIO $ do
  T.pack <$> formatCodeSnippet <$> readFile fileName

codeSnippetSplice :: Splice IO
codeSnippetSplice = do
  node <- getParamNode
  let
    fileName =
      maybe (error $ printf "No attribute \"file\" on element \"%s\"" $ elementName node)
      T.unpack $
      X.getAttribute "file" node
        where elementName :: X.Node -> String
              elementName n = maybe (error "Node is not an element")
                              T.unpack $
                              X.tagName n
  return $ C.yieldRuntimeText $ codeSnippet fileName

main :: IO ()
main = do
  let
    heistConfig = mempty
      {
        hcCompiledSplices = "code-snippet" ## codeSnippetSplice,
        hcTemplateLocations = [loadTemplates "."]
      }
  heistState <- either (error "Malformed template?") id <$>
                (runEitherT $ initHeist heistConfig)
  builder <- maybe (error "oops") fst $
             renderTemplate heistState "templates/index"

  let html = toByteString builder
  B.writeFile "static/index.html" html
  putStrLn "Done"

