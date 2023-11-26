{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (void, (>=>))
import Sdk (initChannel, withConnection, localExchangeName, localTopicName)
import Network.AMQP (Message(msgBody, msgDeliveryMode), DeliveryMode (NonPersistent), newMsg, publishMsg, Channel)
import qualified Data.ByteString.Lazy.Char8 as BL
import Database.Persist.Sqlite (runSqlite, runMigration, withSqliteConn)
import Types (migrateAll)
import Control.Monad.IO.Class (MonadIO(liftIO))
import System.Environment (getEnv)
import qualified Data.Text as T
import Control.Monad.Logger (NoLoggingT(runNoLoggingT))

msg :: Channel -> IO (Maybe Int)
msg channel = do
  publishMsg channel localExchangeName localTopicName
        (newMsg {msgBody = BL.pack "testing",
                 msgDeliveryMode = Just NonPersistent}
                )

main :: IO ()
main = do
  dbString <- fmap T.pack (getEnv "DATABASE")
  runSqlite dbString (runMigration migrateAll)
  runNoLoggingT $
    withSqliteConn
      dbString
      (\db ->
         liftIO $ withConnection (initChannel >=> void . msg))
