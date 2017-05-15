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
  putStrLn "Hey world!"
  args <- getArgs
  putStrLn (concat args)
  putStrLn "What's Up!"
  fileContent <- readFile (head args)
  let
    messages = lines fileContent
    parsedMessages = parseAll messages
    filterMessages = filter (not . null . links)
  -- putStrLn (unlines (map (show . (\ m -> (text m, length (text m)))) parsedMessages))
  -- putStrLn (unlines $ formatWordFrequency $ wordFrequency parsedMessages)
  putStrLn (unlines .  map show . filterMessages $ parsedMessages)