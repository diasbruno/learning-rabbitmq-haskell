{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (void, (>=>))
import MyLib (initChannel, withConnection, localExchangeName, localTopicName)
import Network.AMQP (Message(msgBody, msgDeliveryMode), DeliveryMode (NonPersistent), newMsg, publishMsg, Channel)
import qualified Data.ByteString.Lazy.Char8 as BL

msg :: Channel -> IO (Maybe Int)
msg channel = do
  publishMsg channel localExchangeName localTopicName
        (newMsg {msgBody = BL.pack "testing",
                 msgDeliveryMode = Just NonPersistent}
                )

main :: IO ()
main = withConnection (initChannel >=> void . msg)
