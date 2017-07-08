module Main (main) where

import Parser.MessageParser
import Statistics.WordCount
import Statistics.WordFrequency
import Statistics.LineCount
import Statistics.TimeSlice
import Common.Formatter
import System.Environment
import Data.List
import Data.Time

main :: IO ()
main = do
  args <- getArgs
  fileContent <- readFile (head args)
  timeZone <- getCurrentTimeZone
  let
    messages = lines fileContent
    parsedMessages = parseAll messages
    filterMessages = filter (not . null . links)
    calulation = resolveFunction timeZone (if length args > 1 then tail args else [""])
  putStrLn (unlines . calulation $ parsedMessages)

resolveFunction :: TimeZone -> [String] -> ([Message] -> [String])
resolveFunction tz allArgs
    | functName == "wordCountDistribution" = formatDistribution . wordCountDistribution
    | functName == "wordFrequency"         = formatWordFrequency . wordFrequency
    | functName == "averageLineLength"     = formatAggregate . averageLineLength
    | functName == "linesPerMessage"       = formatAggregate . linesPerMessage
    | functName == "lineCount"             = formatAggregate . lineCount
    | functName == "wordCount"             = formatAggregate . wordCount
    | functName == "uniqueWordCount"       = formatAggregate . uniqueWordCount
    | functName == "sliceByTime"           = formatDistribution . sliceByTime tz (read $ allArgs !! 1)
    | otherwise                            = map show
    where
        functName = head allArgs