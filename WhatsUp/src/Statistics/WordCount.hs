module Statistics.WordCount 
    ( wordCount
    , wordCountDistribution
    , uniqueWordCount
    ) where

import Parser.MessageParser
import Statistics.Tokenizer
import Common.Types
import Common.Utils
import qualified Data.Map as M
import qualified Data.List as L
import qualified Data.Set as S

wordCount :: [Message] -> M.Map String Int
wordCount [] = M.fromList []
wordCount allMsgs =
    groupAndAggregate person (length . wordsInMessage) (+) allMsgs

wordCountDistribution :: [Message] -> CountDistribution
wordCountDistribution [] = M.fromList []
wordCountDistribution messages =
    let
        grouped = group person (length . wordsInMessage) messages
    in
        M.map (groupAndAggregate id (const 1) (+)) grouped

uniqueWordCount :: [Message] -> M.Map String Int
uniqueWordCount [] = M.fromList []
uniqueWordCount allMsgs =
    let
        grouped = groupAndAggregate person (S.fromList . wordsInMessage) S.union allMsgs
    in
        M.map S.size grouped