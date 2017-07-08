module Statistics.WordFrequency 
    ( wordFrequency
    ) where

import Common.Utils
import Parser.MessageParser
import Statistics.Tokenizer
import qualified Data.Map as M

wordFrequency :: [Message] -> M.Map String (M.Map String Int)
wordFrequency [] = M.fromList []
wordFrequency allMsgs =
    let
        groupedByPerson = groupAndAggregate person wordsInMessage (++) allMsgs
        groupByWord = groupAndAggregate id (const 1) (+)
    in
        M.map groupByWord groupedByPerson