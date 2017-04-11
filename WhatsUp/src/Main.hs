module Main (main) where

import Parser.MessageParser
import Statistics.WordCount
import System.Environment

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
  --putStrLn (unlines (map show (parseAll messages)))
  print (wordCount parsedMessages)