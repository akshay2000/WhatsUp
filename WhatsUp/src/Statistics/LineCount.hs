module Statistics.LineCount 
    (
     lineCount
    ,averageLineLength 
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