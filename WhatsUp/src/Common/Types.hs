module Common.Types 
    ( CountDistribution
    ) where

import qualified Data.Map as M

type CountDistribution = M.Map String (M.Map Int Int)