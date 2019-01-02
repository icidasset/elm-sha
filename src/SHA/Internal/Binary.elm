module SHA.Internal.Binary exposing (fromUtf8String)

import Binary exposing (Bits)
import List.Extra as List


{-| Convert a string to UTF-8 bits.

    >>> import Binary
    >>> "🤶"
    ..>   |> fromUtf8String
    ..>   |> Binary.toHex
    "F09FA4B6"

    >>> "abc"
    ..>   |> fromUtf8String
    ..>   |> Binary.toHex
    "616263"

-}
fromUtf8String : String -> Bits
fromUtf8String string =
    string
        |> String.toList
        |> List.concatMap unicodeCharToUtf8Bits
        |> Binary.fromIntegers



-- PRIVATE


{-| Translate a single unicode code-point to multiple utf-8 code-points.
-}
unicodeCharToUtf8Bits : Char -> List Int
unicodeCharToUtf8Bits char =
    let
        codepoint =
            Char.toCode char
    in
    if codepoint < 128 then
        -- 1-bit UTF-8
        codepoint
            |> Binary.fromDecimal
            |> Binary.ensureSize 8
            |> Binary.toIntegers

    else if codepoint < 2048 then
        -- 2-bit UTF-8
        unicodeCharToUtf8Bits_
            [ [ 1, 1, 0 ]
            , [ 1, 0 ]
            ]
            codepoint

    else if codepoint < 65536 then
        -- 3-bit UTF-8
        unicodeCharToUtf8Bits_
            [ [ 1, 1, 1, 0 ]
            , [ 1, 0 ]
            , [ 1, 0 ]
            ]
            codepoint

    else
        -- 4-bit UTF-8
        unicodeCharToUtf8Bits_
            [ [ 1, 1, 1, 1, 0 ]
            , [ 1, 0 ]
            , [ 1, 0 ]
            , [ 1, 0 ]
            ]
            codepoint


unicodeCharToUtf8Bits_ : List (List Int) -> Int -> List Int
unicodeCharToUtf8Bits_ startingBits codepoint =
    startingBits
        |> List.foldr
            (\start ( all, acc ) ->
                let
                    takeAway =
                        8 - List.length start

                    ( end, rest ) =
                        List.splitAt takeAway acc
                in
                ( start ++ List.reverse end ++ all
                , rest
                )
            )
            ( []
            , codepoint
                |> Binary.fromDecimal
                |> Binary.ensureSize (8 * List.length startingBits)
                |> Binary.toIntegers
                |> List.reverse
            )
        |> Tuple.first
