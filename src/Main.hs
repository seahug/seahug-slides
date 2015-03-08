{-# LANGUAGE OverloadedStrings  #-}
import Data.Monoid
import qualified Data.ByteString as B
import Blaze.ByteString.Builder
import Control.Monad
import Control.Applicative
import Control.Monad.Trans.Either
import Heist
import Heist.Compiled as C
splice :: Splice IO
splice = C.runChildren

main = do
    let heistConfig = mempty
            { 
              hcCompiledSplices = 
                    "foo" ## splice
            , hcTemplateLocations =
                    [loadTemplates "."]            
            }            
    heistState <- either (error "oops") id <$> 
         (runEitherT $ initHeist heistConfig)
    builder <- maybe (error "oops") fst $
         renderTemplate heistState "templates/index"
    let html = toByteString builder
    B.writeFile "static/index.html" html
