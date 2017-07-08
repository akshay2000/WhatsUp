module Statistics.TimeSlice 
    ( SliceType (Hour)
    , sliceByTime
    ) where

import Common.Types
import Common.Utils
import Parser.MessageParser
import Data.Time
import qualified Data.Map as M
import qualified Data.List as L

data SliceType = Hour | DayOfWeek | DayOfMonth deriving (Show, Read)

sliceByTime :: TimeZone -> SliceType -> [Message] -> CountDistribution
sliceByTime tz sliceType messages =
    let
        groupedByPerson = group person timeStamp messages
        groupBySlice = groupAndAggregate (timeStampToSlice tz sliceType) (const 1) (+)
    in
        M.map groupBySlice groupedByPerson

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
