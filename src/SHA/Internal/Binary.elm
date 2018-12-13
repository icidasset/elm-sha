module SHA.Internal.Binary exposing (empty, fromString)

import Binary exposing (Bits)


{-| Convert a string to binary.

    Uses the UTF-8 text-encoding.

    >>> import Binary
    >>> "🤶"
    ..>   |> fromString
    ..>   |> Binary.toHex
    "1F936"

    >>> "abc"
    ..>   |> fromString
    ..>   |> Binary.toHex
    "616263"

-}
fromString : String -> Bits
fromString string =
    string
        |> String.toList
        |> List.map (Char.toCode >> Binary.fromDecimal >> Binary.ensureBits 8)
        |> Binary.concat


{-| Empty binary sequence.
-}
empty : Bits
empty =
    Binary.fromBooleans []
