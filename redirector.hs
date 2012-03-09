{-# LANGUAGE OverloadedStrings #-}
module Main where
import Network.Wai
import Network.Wai.Handler.Warp
import qualified Network.HTTP.Types as H

main :: IO ()
main = run 8888 application

application :: Application
application req@Request {pathInfo=["test"]} = do
  return $ responseLBS H.status303 [("location", "http://konn-san.com/test2/")] "moved"
application _ = return $ responseLBS H.status200 [] "it works!"
