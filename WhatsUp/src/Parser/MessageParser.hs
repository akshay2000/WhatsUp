module Parser.MessageParser 
    ( parseMessage
    , parseAll
    , extractLinksFromText
    , Message(..)
    ) where

import Data.Time
import Data.List
import Common.Constants
import Text.Regex.Posix

data Message = Message 
    { timeStamp :: UTCTime
    , person :: String
    , text :: String
    , images :: Int
    , videos :: Int
    , voiceNotes ::Int
    , links :: [String]
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
parseMessage x = Message 
    { timeStamp=extractTimeStamp x
    , person=extractPerson x
    , text=extractMessage x 
    , images = 0
    , videos = 0
    , voiceNotes = 0
    , links = []
    }

extractMetaData :: Message -> Message
extractMetaData m 
    | _IMAGE_OMITTED `isPrefixOf` msgTxt = extractMetaData . incrementImageCount . dropPrefix (length _IMAGE_OMITTED) $ m
    | _VIDEO_OMITTED `isPrefixOf` msgTxt = extractMetaData . incrementVideoCount . dropPrefix (length _VIDEO_OMITTED) $ m
    | _VOICE_MESSAGE_OMITTED `isPrefixOf` msgTxt = extractMetaData . incrementVoiceNoteCount . dropPrefix (length _VOICE_MESSAGE_OMITTED) $ m
    | otherwise = m
    where
        msgTxt = text m
        incrementImageCount m = m { images = images m + 1 }
        incrementVideoCount m = m { videos = videos m + 1 }
        incrementVoiceNoteCount m = m { voiceNotes = voiceNotes m + 1 }
        dropPrefix len m = m { text = drop len (text m) }

extractLinks :: Message -> Message
extractLinks m =
    let
        (message, nLinks) = extractLinksFromText $ text m
    in
        m { text = message, links = nLinks }

extractLinksFromText :: String -> (String, [String])
extractLinksFromText text =
    (reverseConcat message, allLinks)
    where
        (message, allLinks, _) = sliceLinks ([], [], text)
        reverseConcat = concat . reverse

sliceLinks :: ([String], [String], String) -> ([String], [String], String)
sliceLinks (prev, inLinks, next)
    | noMoreLinks next :: Bool = (next:prev, inLinks, "")
    | otherwise = sliceLinks (nBefore:prev, nLink:inLinks, nAfter)
    where
        noMoreLinks t = not (next =~ _LINK_REGEX)
        (nBefore, nLink, nAfter) = next =~ _LINK_REGEX :: (String, String, String)    

parseAll :: [String] -> [Message]
parseAll lines =
    let
        preparedLines = prepare lines
    in
        map (extractLinks . extractMetaData . parseMessage) preparedLines