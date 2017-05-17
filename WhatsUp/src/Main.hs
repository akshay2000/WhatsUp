module Main (main) where

import Parser.MessageParser
import Statistics.WordCount
import Statistics.WordFrequency
import Statistics.LineCount
import Common.Formatter
import System.Environment
import Data.List

main :: IO ()
main = do
  args <- getArgs
  putStrLn (concat args)
  fileContent <- readFile (head args)
  let
    messages = lines fileContent
    parsedMessages = parseAll messages
    filterMessages = filter (not . null . links)
    calulation = resolveFunction $ if length args > 1 then args !! 1 else ""
  putStrLn (unlines . calulation $ parsedMessages)

resolveFunction :: String -> ([Message] -> [String])
resolveFunction "wordCountDistribution" = formatDistribution . wordCountDistribution
resolveFunction "wordFrequency" = formatWordFrequency . wordFrequency
resolveFunction _ = map show