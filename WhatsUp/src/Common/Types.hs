module Common.Types 
    ( CountDistribution
    , CountDistribution'
    ) where

import qualified Data.Map as M

type CountDistribution = M.Map Int Int
type CountDistribution' = M.Map Int (M.Map String Int)