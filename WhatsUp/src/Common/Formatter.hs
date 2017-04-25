module Common.Formatter 
    ( formatDistribution
    ) where

import Common.Types
import qualified Data.Map as M
import qualified Data.List as L

formatCountDistribution :: CountDistribution -> [String]
formatCountDistribution inMap = L.map (\(a, b) -> show a ++ "," ++ show b) (M.toList inMap)
    

formatDistribution :: M.Map String CountDistribution -> [String]
formatDistribution dist = 
    let
        untupled = M.map formatCountDistribution dist
        flattened = L.map (uncurry (:)) (M.toList untupled)
    in
        concat flattened

