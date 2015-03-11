{-# OPTIONS_GHC -fwarn-unused-imports #-}
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
import System.Directory
import System.FilePath
import Text.Blaze.Html (toHtml)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Text.Printf (printf)
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C8 (pack)
import qualified Data.Text as T
import qualified System.FilePath.Glob as Glob
import qualified Text.XmlHtml as X

escapeHtml :: String -> String
escapeHtml = renderHtml . toHtml

formatCodeSnippet :: String -> String
formatCodeSnippet = (S.replace " " "&nbsp;") . (S.replace "\n" "<br/>\n") . escapeHtml

codeSnippet :: String -> RuntimeSplice IO T.Text
codeSnippet fileName = liftIO $ do
  T.pack <$> formatCodeSnippet <$> readFile fileName

missingAttrMessage :: X.Node -> T.Text -> String
missingAttrMessage node name =
  printf "No attribute \"%s\" on element \"%s\"" (T.unpack name) (elementName node)
  where elementName :: X.Node -> String
        elementName n = maybe (error "Node is not an element")
                        T.unpack $
                        X.tagName n

getRequiredAttr :: X.Node -> T.Text -> String
getRequiredAttr node name =
  maybe (error $ missingAttrMessage node name)
  T.unpack $
  X.getAttribute name node

codeSnippetSplice :: Splice IO
codeSnippetSplice = do
  node <- getParamNode
  let fileName = getRequiredAttr node "file"
  return $ C.yieldRuntimeText $ codeSnippet fileName

renderHtmlFile :: HeistState IO -> String -> String -> IO ()
renderHtmlFile heistState templateFileName htmlFileName = do
  builder <- maybe (error "Failed to render template") fst $
             renderTemplate heistState $ C8.pack $ dropExtension templateFileName
  let html = toByteString builder
  B.writeFile htmlFileName html

templateDir :: String
templateDir = "templates"

staticDir :: String
staticDir = "static"

createFileNamePair :: FilePath -> (FilePath, FilePath)
createFileNamePair fileName =
  (templateDir ++ "/" ++ fileName, staticDir ++ "/" ++ (replaceExtension fileName ".html"))

main :: IO ()
main = do
  let pattern = Glob.compile "*.tpl"
  fileNamePairs <- map createFileNamePair <$> filter (Glob.match pattern) <$> getDirectoryContents templateDir

  let heistConfig = mempty {
        hcCompiledSplices = "code-snippet" ## codeSnippetSplice,
        hcTemplateLocations = [loadTemplates "."]
      }

  heistState <- either (error "Malformed template") id <$>
                (runEitherT $ initHeist heistConfig)

  forM_ fileNamePairs $ \p -> do
    renderHtmlFile heistState (fst p) (snd p)

