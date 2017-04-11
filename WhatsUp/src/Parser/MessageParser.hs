module Parser.MessageParser 
    ( parseMessage
    , parseAll
    , Message(..)
    ) where

import Data.Time
import Data.List

data Message = Message 
    { timeStamp :: UTCTime
    , person :: String
    , text :: String
    } deriving (Show)

startsWithTimeStamp :: String -> Bool
startsWithTimeStamp val = length val > 16 && val !! 2 == '-' && val !! 5 == '-' && val !! 13 == ':' && val !! 16 == ':'

prepare :: [String] -> [String]
prepare [] = []
prepare list = 
    let
        unlines' = intercalate "\n" 
    in
        map unlines' (groupBy(\_ line -> not (startsWithTimeStamp line)) list)

extractTimeStamp :: String -> UTCTime
extractTimeStamp x =
    let
        timeString = take 22 x
        timeFormatString = "%d-%m-%0Y %H:%M:%S %p %z"
    in
        parseTimeOrError True defaultTimeLocale timeFormatString (timeString ++ " +0530") :: UTCTime

extractPerson :: String -> String
extractPerson = takeWhile (/= ':') . drop 24

extractMessage :: String -> String
extractMessage = drop 2 . dropWhile (/= ':') . drop 24

parseMessage :: String -> Message
parseMessage x = Message {timeStamp=extractTimeStamp x, person=extractPerson x, text=extractMessage x }

parseAll :: [String] -> [Message]
parseAll lines =
    let
        preparedLines = prepare lines
    in
        map parseMessage preparedLines