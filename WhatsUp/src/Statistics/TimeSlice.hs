module Statistics.TimeSlice 
    ( SliceType (Hour)
    , sliceByTime
    ) where

import Common.Types
import Parser.MessageParser
import Data.Time
import qualified Data.Map as M
import qualified Data.List as L

data SliceType = Hour | DayOfWeek | DayOfMonth deriving (Show, Read)

sliceByTime :: TimeZone -> SliceType -> [Message] -> CountDistribution
sliceByTime tz sliceType =
    groupBySlice . groupByPerson . extractData
    where
        extractData = L.map (\m -> (person m, [timeStampToSlice tz sliceType . timeStamp $ m]))
        groupByPerson = M.fromListWith (++)
        groupBySlice = M.map groupSliceKeys
            where
                groupSliceKeys = M.fromListWith (+) . L.map (\s -> (s, 1))
        

timeStampToSlice :: TimeZone -> SliceType -> UTCTime -> Int
timeStampToSlice tz sliceType uTime = 
    slice sliceType lTime
    where
        lTime = utcToLocalTime tz uTime
        slice Hour = todHour . localTimeOfDay
        slice DayOfWeek = read . formatTime defaultTimeLocale "%w"
        slice DayOfMonth = thrd . toGregorian . localDay
            where
                thrd (_, _, x) = x
