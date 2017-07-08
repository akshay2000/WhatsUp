module Common.Utils
    ( group
    , groupAndAggregate
    ) where

import qualified Data.Map as M
import qualified Data.List as L
import Control.Arrow

group :: (Ord k) => (iv -> k) -> (iv -> ov) -> [iv] -> M.Map k [ov]
group keyFunct valFunct =
        M.fromListWith (++) . L.map (\inVal -> (keyFunct inVal, [valFunct inVal]))

groupAndAggregate :: (Ord k) => (iv -> k) -> (iv -> ov) -> (ov -> ov -> ov) -> [iv] -> M.Map k ov
groupAndAggregate keyFunct valFunct aggFunnt =
    M.fromListWith aggFunnt . L.map (keyFunct &&& valFunct)