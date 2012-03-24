{-# LANGUAGE OverloadedStrings #-}
module Main where
import Network.Wai
import Network.Wai.Handler.Warp
import qualified Network.HTTP.Types as H
import Control.Monad.IO.Class
import qualified Data.ByteString.Lazy.Char8 as LBS
import Network.HTTP.Types

main :: IO ()
main = run 8910 application

application :: Application
application req = do
  return $ responseLBS status200 [("Content-Type", "text/plain")] $ LBS.pack $ show $ queryString req
