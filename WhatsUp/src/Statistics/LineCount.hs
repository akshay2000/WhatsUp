module Statistics.LineCount 
    ( lineCount
    , averageLineLength 
    , linesPerMessage
    ) where

import Parser.MessageParser
import Common.Types
import Common.Utils
import qualified Data.Map as M

lineCount :: [Message] -> M.Map String Int
lineCount [] = M.fromList []
lineCount messages =
    groupAndAggregate person (length . lines . text) (+) messages

averageLineLength :: Fractional a => [Message] -> M.Map String a
averageLineLength [] = M.fromList []
averageLineLength messages = 
    let
        lengths' = groupAndAggregate person (\m -> sum (map length (lines . text $ m))) (+) messages        
        lengths = M.map fromIntegral lengths'
        counts = M.map fromIntegral (lineCount messages)
    in
        M.unionWith (/) lengths counts

linesPerMessage :: Fractional a => [Message] -> M.Map String a
linesPerMessage [] = M.fromList []
linesPerMessage messages =
    let
        filtered = filter (\m -> length (lines $ text m) > 1) messages
        messageCounts' = groupAndAggregate person (const 1) (+) filtered
        messageCounts =  M.map fromIntegral messageCounts'
        lineCounts = M.map fromIntegral (lineCount filtered)
    in
        M.unionWith (/) lineCounts messageCounts
