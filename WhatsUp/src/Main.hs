module Main (main) where

import Parser.MessageParser
import Statistics.WordCount
import Statistics.WordFrequency
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
  --putStrLn (unlines (map (show . (\ m -> (text m, length (text m)))) parsedMessages))
  print (wordFrequency parsedMessages)