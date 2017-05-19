module Statistics.WordCount 
    ( wordCount
    , wordCountDistribution
    , uniqueWordCount
    ) where

import Parser.MessageParser
import Statistics.Tokenizer
import Common.Types
import qualified Data.Map as M
import qualified Data.List as L
import qualified Data.Set as S

wordCount :: [Message] -> M.Map String Int
wordCount [] = M.fromList []
wordCount allMsgs =
    let
        personVsCount = map (\m -> (person m, length $ wordsInMessage m)) allMsgs
    in
        M.fromListWith (+) personVsCount

wordCountDistribution :: [Message] -> CountDistribution
wordCountDistribution [] = M.fromList []
wordCountDistribution messages =
    let
        tuples = map (\m -> (person m, [(length $ wordsInMessage m, 1)])) messages
        grouped = M.fromListWith (++) tuples
    in
        M.map (M.fromListWith (+)) grouped

uniqueWordCount :: [Message] -> M.Map String Int
uniqueWordCount [] = M.fromList []
uniqueWordCount allMsgs =
    let
        allNubs = L.map (\msg -> (person msg, S.fromList $ wordsInMessage msg)) allMsgs       
        grouped = M.fromListWith S.union allNubs
    in
        M.map S.size grouped