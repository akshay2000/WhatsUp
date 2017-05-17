module Common.Formatter 
    ( formatDistribution
    , formatWordFrequency
    , formatAggregate
    ) where

import Common.Types
import qualified Data.Map as M
import qualified Data.List as L

keyOrderedValues :: M.Map a b -> [b]
keyOrderedValues inMap = L.map snd (M.toList inMap)

formatDistribution :: CountDistribution -> [String]
formatDistribution dist = 
    let
        maxInEach = fst . M.findMax
        maxLength = L.maximum . M.elems $ M.map maxInEach dist
        identity = M.fromList $ take (maxLength + 1) (zip [0,1..] (repeat 0))
        unions = M.map (M.unionWith (+) identity) dist
        names = L.intercalate "," (M.keys unions)
        values = L.map keyOrderedValues (keyOrderedValues unions)
        transposed = L.transpose values
        indexed = L.zipWith (:) [0, 1..] transposed
        removeZeroes = L.filter (\xs -> sum (tail xs) /= 0)
        allLines = L.map (L.intercalate "," . map show) (removeZeroes indexed)
    in
        ("Index," ++ names) : allLines

formatWordFrequency :: M.Map String (M.Map String Int) -> [String]
formatWordFrequency m =
    concatMap (\(person, freq) -> person : formatPersonFrequency freq) (M.toList m)
    where
        formatPersonFrequency freq = L.map (\(word, count) -> word ++ "," ++ show count) (M.toList freq)

formatAggregate :: (Show a) => M.Map String a -> [String]
formatAggregate m = [headers, values]
    where
        headers = L.intercalate "," (M.keys m)
        values = L.intercalate "," (L.map show (keyOrderedValues m))