module Statistics.WordCount 
    ( wordCount
    , wordCountDistribution
    , wordCountDistribution'
    ) where

import Parser.MessageParser
import Statistics.Tokenizer
import Common.Types
import qualified Data.Map as M
import qualified Data.List as L

wordCount :: [Message] -> M.Map String Int
wordCount [] = M.fromList []
wordCount allMsgs =
    let
        personVsCount = map (\m -> (person m, length $ wordsInMessage m)) allMsgs
    in
        M.fromListWith (+) personVsCount

wordCountDistribution :: [Message] -> M.Map String CountDistribution
wordCountDistribution [] = M.fromList []
wordCountDistribution messages =
    let
        tuples = map (\m -> (person m, [(length $ wordsInMessage m, 1)])) messages
        grouped = M.fromListWith (++) tuples
    in
        M.map (M.fromListWith (+)) grouped

wordCountDistribution' :: [Message] -> M.Map Int (M.Map String Int)
wordCountDistribution' [] = M.fromList []
wordCountDistribution' messages = 
    let
        identity = M.fromList(zip (L.nub $ map person messages) (repeat 0))
        tuples = map (\m -> (length $ wordsInMessage m, [(person m, 1)])) messages
        grouped = M.fromListWith (++) tuples
        allGrouped = M.map (M.fromListWith (+)) grouped        
    in
        M.map (M.unionWith (+) identity) allGrouped