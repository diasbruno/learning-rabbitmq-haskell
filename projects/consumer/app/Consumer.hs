{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (void)
import Control.Monad.Logger (NoLoggingT (runNoLoggingT))
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text as T
import Database.Persist.Sql (runMigration)
import Database.Persist.Sqlite (runSqlite, withSqliteConn)
import Network.AMQP (Ack (Ack), Envelope, Message (msgBody), ackEnv, consumeMsgs)
import Sdk (initChannel, localQueueName, withConnection)
import System.Environment (getEnv)
import Types (migrateAll)
import Control.Monad.Cont (MonadIO(liftIO))

myCallback :: (Message, Envelope) -> IO ()
myCallback (msg, env) = do
  putStrLn $ "received: " ++ BL.unpack (msgBody msg)
  ackEnv env

main :: IO ()
main = do
  dbString <- fmap T.pack (getEnv "DATABASE")
  runSqlite dbString (runMigration migrateAll)
  runNoLoggingT $
    withSqliteConn
      dbString
      ( \_ ->
          liftIO $ withConnection
            ( \conn -> do
                channel <- initChannel conn
                void (consumeMsgs channel localQueueName Ack myCallback)
                void getLine
            )
      )
