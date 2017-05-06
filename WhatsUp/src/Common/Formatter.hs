module Common.Formatter 
    ( formatDistribution
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
