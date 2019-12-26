{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.ByteString.Char8 as BS
import qualified Data.Text.IO          as TIO

import           Network.HTTP.Simple (httpBS, getResponseBody)
import           Control.Lens        (preview)
import           Data.Aeson.Lens     (key, _String)
import           Data.Text           (Text)


fetchJSON :: IO BS.ByteString
fetchJSON = do
  res <- httpBS "https://api.coindesk.com/v1/bpi/currentprice.json"
  return (getResponseBody res)

getRate :: BS.ByteString -> Maybe Text
getRate = preview (key "bpi" . key "USD" . key "rate" . _String)

main :: IO ()
main = do
  json <- fetchJSON
  case getRate json of
    Nothing -> TIO.putStrLn "Could not find the bit coin rate :("
    Just rate -> TIO.putStrLn $ "The current Bitcoin rate is " <> rate <> "$"
