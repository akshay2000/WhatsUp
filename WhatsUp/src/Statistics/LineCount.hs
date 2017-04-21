module Statistics.LineCount 
    ( lineCount
    , averageLineLength 
    , linesPerMessage
    , lineCountDistribution
    ) where

import Parser.MessageParser
import qualified Data.Map as M

lineCount :: [Message] -> M.Map String Int
lineCount [] = M.fromList []
lineCount messages =
    let
        tuples = map (\m -> (person m, length $ lines $ text m)) messages
    in
        M.fromListWith (+) tuples

averageLineLength :: Fractional a => [Message] -> M.Map String a
averageLineLength [] = M.fromList []
averageLineLength messages = 
    let
        allLengths = map (\m -> (person m, sum (map length (lines $ text m)))) messages
        lengths = M.map fromIntegral (M.fromListWith (+) allLengths)
        counts = M.map fromIntegral (lineCount messages)
    in
        M.unionWith (/) lengths counts

linesPerMessage :: Fractional a => [Message] -> M.Map String a
linesPerMessage [] = M.fromList []
linesPerMessage messages =
    let
        filtered = filter (\m -> length (lines $ text m) > 1) messages
        tuples = map (\m -> (person m, 1)) filtered
        messageCounts =  M.map fromIntegral (M.fromListWith (+) tuples)
        lineCounts = M.map fromIntegral (lineCount filtered)
    in
        M.unionWith (/) lineCounts messageCounts

type CountDistribution = M.Map Int Int

lineCountDistribution :: [Message] -> M.Map String CountDistribution
lineCountDistribution [] = M.fromList []
lineCountDistribution messages =
    let
        tuples = map (\m -> (person m, [(length $ lines $ text m, 1)])) messages
        grouped = M.fromListWith (++) tuples
    in
        M.map (M.fromListWith (+)) grouped
