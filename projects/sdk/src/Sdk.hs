{-# LANGUAGE OverloadedStrings          #-}
module Sdk where

import Control.Monad (void)
import Data.Text (Text)
import Network.AMQP (Channel, Connection, ExchangeOpts (exchangeName, exchangeType), QueueOpts (queueName), bindQueue, closeConnection, declareExchange, declareQueue, newExchange, newQueue, openChannel, openConnection)

rmqHost :: String
rmqPath,
  rmqUser,
  rmqPass ::
    Text
rmqHost = "localhost"
rmqPath = "/"
rmqUser = "rabbit"
rmqPass = "rabbit"

topicExchangeType :: Text
topicExchangeType = "topic"

localQueueName :: Text
localQueueName = "queue"

localExchangeName :: Text
localExchangeName = "exchange"

localTopicName :: Text
localTopicName = "atopic"

withConnection :: (Connection -> IO ()) -> IO ()
withConnection f = do
  conn <- openConnection rmqHost rmqPath rmqUser rmqPass
  void (f conn)
  closeConnection conn

initChannel :: Connection -> IO Channel
initChannel conn = do
  channel <- openChannel conn

  _ <- declareQueue channel newQueue {queueName = localQueueName}

  let e =
        newExchange
          { exchangeName = localExchangeName,
            exchangeType = topicExchangeType
          }

  declareExchange channel e

  bindQueue channel localQueueName localExchangeName localTopicName

  return channel
