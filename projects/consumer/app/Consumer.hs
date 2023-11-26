{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (void)
import qualified Data.ByteString.Lazy.Char8 as BL
import Sdk (initChannel, localQueueName, withConnection)
import Network.AMQP (Ack (Ack), Envelope, Message (msgBody), consumeMsgs, ackEnv)

myCallback :: (Message, Envelope) -> IO ()
myCallback (msg, env) = do
  putStrLn $ "received: " ++ BL.unpack (msgBody msg)
  ackEnv env

main :: IO ()
main =
  withConnection
    ( \conn -> do
        channel <- initChannel conn
        void (consumeMsgs channel localQueueName Ack myCallback)
        void getLine
    )
