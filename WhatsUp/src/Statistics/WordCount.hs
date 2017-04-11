module Statistics.WordCount 
    ( wordCount
    ) where

import Parser.MessageParser
import Statistics.Tokenizer
import qualified Data.Map as M

wordCount :: [Message] -> M.Map String Int
wordCount [] = M.fromList []
wordCount allMsgs =
    let
        personVsCount = map (\m -> (person m, length $ wordsInMessage m)) allMsgs
    in
        M.fromListWith (+) personVsCount