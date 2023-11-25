{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (void)
import qualified Data.ByteString.Lazy.Char8 as BL
import MyLib (initChannel, localQueueName, withConnection)
import Network.AMQP (Ack (Ack), Envelope, Message (msgBody), consumeMsgs)

myCallback :: (Message, Envelope) -> IO ()
myCallback (msg, _env) = do
  putStrLn $ "received: " ++ BL.unpack (msgBody msg)

main :: IO ()
main =
  withConnection
    ( \conn -> do
        channel <- initChannel conn
        void (consumeMsgs channel localQueueName Ack myCallback)
        void getLine
    )
