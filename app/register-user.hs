{-# LANGUAGE OverloadedStrings #-}
module Main where
import Yesod.Auth.HashDB hiding (UserId, UserGeneric(..), UniqueUser)
import Database.Persist.Store
import Database.Persist.Sqlite
import System.Environment
import Yesod.Default.Config (withYamlEnvironment, DefaultEnv(..))
import Control.Applicative

import Data.Text.IO
import Data.Text hiding (head)
import Prelude hiding (getLine, lines, putStr)
import qualified Settings
import System.IO (hFlush, stdout)
import Model

main :: IO ()
main = do
  [env] <- getArgs
  dbconf <- applyEnv =<< withYamlEnvironment "config/sqlite.yml"
                           (read env :: DefaultEnv) loadConfig
  p <- createPoolConfig (dbconf :: Settings.PersistConfig)
  putStr "enter user name: " >> hFlush stdout
  ident <- head . lines <$> getLine
  putStr "enter passwd: " >> hFlush stdout
  pass <- head . lines <$> getLine
  usr <- setPassword pass (User ident "" Nothing) :: IO (UserGeneric SqlPersist)
  k <- Database.Persist.Store.runPool dbconf (runMigration migrateAll >> insert usr) p
  print k
