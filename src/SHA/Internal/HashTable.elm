module SHA.Internal.HashTable exposing (HashTable, combineHashTables, hashTableToBits, partialHashTableToBits)

import Binary exposing (Bits)
import SHA.Internal.Common exposing (combine)



-- HASH TABLES


type alias HashTable =
    { a : Bits
    , b : Bits
    , c : Bits
    , d : Bits
    , e : Bits
    , f : Bits
    , g : Bits
    , h : Bits
    }


combineHashTables : Int -> HashTable -> HashTable -> HashTable
combineHashTables sizeInBits x y =
    { a = combine sizeInBits x.a y.a
    , b = combine sizeInBits x.b y.b
    , c = combine sizeInBits x.c y.c
    , d = combine sizeInBits x.d y.d
    , e = combine sizeInBits x.e y.e
    , f = combine sizeInBits x.f y.f
    , g = combine sizeInBits x.g y.g
    , h = combine sizeInBits x.h y.h
    }


{-| Convert a `HashTable` to `Bits`.

    >>> import Binary
    >>> { a = Binary.fromHex "0B6ED64E"
    ..> , b = Binary.fromHex "650C0627"
    ..> , c = Binary.fromHex "3F72FA0E"
    ..> , d = Binary.fromHex "E37A31C2"
    ..> , e = Binary.fromHex "3B37FB03"
    ..> , f = Binary.fromHex "65550159"
    ..> , g = Binary.fromHex "49F5F8A9"
    ..> , h = Binary.fromHex "384FA8DA"
    ..> }
    ..>   |> hashTableToBits
    ..>   |> Binary.toHex
    ..>   |> String.toLower
    "0b6ed64e650c06273f72fa0ee37a31c23b37fb036555015949f5f8a9384fa8da"

-}
hashTableToBits : HashTable -> Bits
hashTableToBits =
    partialHashTableToBits [ .a, .b, .c, .d, .e, .f, .g, .h ]


partialHashTableToBits : List (HashTable -> Bits) -> HashTable -> Bits
partialHashTableToBits accessors hashTable =
    accessors
        |> List.map (\accessor -> accessor hashTable)
        |> Binary.concat
