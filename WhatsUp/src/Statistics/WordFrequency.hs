module Statistics.WordFrequency 
    ( wordFrequency
    ) where

import Parser.MessageParser
import Statistics.Tokenizer
import qualified Data.Map as M

wordFrequency :: [Message] -> M.Map String (M.Map String Int)
wordFrequency [] = M.fromList []
wordFrequency allMsgs =
    let        
        wordsToTuples = map (\w -> (w, 1))
        allTriples = map (\m -> (person m, wordsToTuples $ wordsInMessage m)) allMsgs
        grouped = M.fromListWith (++) allTriples
    in
        M.map (M.fromListWith (+)) grouped