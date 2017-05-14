module Statistics.Tokenizer (
    wordsInMessage
    ) where

import Parser.MessageParser

removePunctuation :: String -> String
removePunctuation = map punctMapper

punctMapper :: Char -> Char
punctMapper '.' = ' '
punctMapper '!' = ' '
punctMapper '?' = ' '
punctMapper ',' = ' '
punctMapper '*' = ' '
punctMapper '_' = ' '
punctMapper '\"' = ' '
punctMapper c = c

wordsInMessage :: Message -> [String]
wordsInMessage m = words $ removePunctuation $ text m