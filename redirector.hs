{-# LANGUAGE OverloadedStrings #-}
module Main where
import Network.Wai
import Network.Wai.Handler.Warp
import qualified Network.HTTP.Types as H
import Control.Monad.IO.Class

main :: IO ()
main = run 8910 application

application :: Application
application req@Request {pathInfo=["test"]} = do
  liftIO $ print $ httpVersion req
  let status = if httpVersion req >= H.http11
               then H.status303
               else H.status302
  return $ responseLBS status [("location", "http://konn-san.com/test2/")] "moved"
application _ = return $ responseLBS H.status200 [] "it works!"
