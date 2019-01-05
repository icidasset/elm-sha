module SHA.Internal.SHA256 exposing (chunkSize, compressor, computationSetup, extender, initialHashTable, roundConstants)

import Array exposing (Array)
import Binary exposing (Bits)
import SHA.Internal.Common
import SHA.Internal.Computation as Computation
import SHA.Internal.HashTable exposing (HashTable)



-- ⚡️


chunkSize : Int
chunkSize =
    512


computationSetup : Computation.Setup
computationSetup =
    { extender = extender
    , compressor = compressor

    -- Constants
    , chunkSize = chunkSize
    , initialHashTable = initialHashTable
    , roundConstants = roundConstants
    }


combine : Bits -> Bits -> Bits
combine =
    SHA.Internal.Common.combine (chunkSize // 16)



-- EXTENDING


extender : { i2 : Bits, i7 : Bits, i15 : Bits, i16 : Bits } -> Bits
extender { i2, i7, i15, i16 } =
    let
        a =
            Binary.shiftRightZfBy 3 i15
                |> Binary.xor (Binary.rotateRightBy 18 i15)
                |> Binary.xor (Binary.rotateRightBy 7 i15)

        b =
            Binary.shiftRightZfBy 10 i2
                |> Binary.xor (Binary.rotateRightBy 19 i2)
                |> Binary.xor (Binary.rotateRightBy 17 i2)
    in
    List.foldl
        combine
        Binary.empty
        [ i16, a, i7, b ]



-- COMPRESSION


compressor : { index : Int, scheduleNumber : Bits } -> HashTable -> HashTable
compressor { index, scheduleNumber } hashTable =
    let
        -- X
        x1 =
            Binary.rotateRightBy 25 hashTable.e
                |> Binary.xor (Binary.rotateRightBy 11 hashTable.e)
                |> Binary.xor (Binary.rotateRightBy 6 hashTable.e)

        x2 =
            Binary.xor
                (Binary.and hashTable.e hashTable.f)
                (Binary.and (Binary.not hashTable.e) hashTable.g)

        x =
            List.foldl
                combine
                Binary.empty
                [ hashTable.h
                , x1
                , x2
                , Maybe.withDefault Binary.empty (Array.get index roundConstants)
                , scheduleNumber
                ]

        -- Y
        y1 =
            Binary.rotateRightBy 22 hashTable.a
                |> Binary.xor (Binary.rotateRightBy 13 hashTable.a)
                |> Binary.xor (Binary.rotateRightBy 2 hashTable.a)

        y2 =
            hashTable.c
                |> Binary.and hashTable.b
                |> Binary.xor (Binary.and hashTable.a hashTable.c)
                |> Binary.xor (Binary.and hashTable.a hashTable.b)

        y =
            combine y1 y2
    in
    { a = combine x y
    , b = hashTable.a
    , c = hashTable.b
    , d = hashTable.c
    , e = combine hashTable.d x
    , f = hashTable.e
    , g = hashTable.f
    , h = hashTable.g
    }



-- CONSTANTS


initialHashTable : HashTable
initialHashTable =
    { a = Binary.fromHex "6A09E667"
    , b = Binary.fromHex "BB67AE85"
    , c = Binary.fromHex "3C6EF372"
    , d = Binary.fromHex "A54FF53A"
    , e = Binary.fromHex "510E527F"
    , f = Binary.fromHex "9B05688C"
    , g = Binary.fromHex "1F83D9AB"
    , h = Binary.fromHex "5BE0CD19"
    }


roundConstants : Array Bits
roundConstants =
    Array.fromList
        [ Binary.fromHex "428A2F98"
        , Binary.fromHex "71374491"
        , Binary.fromHex "B5C0FBCF"
        , Binary.fromHex "E9B5DBA5"
        , Binary.fromHex "3956C25B"
        , Binary.fromHex "59F111F1"
        , Binary.fromHex "923F82A4"
        , Binary.fromHex "AB1C5ED5"
        , Binary.fromHex "D807AA98"
        , Binary.fromHex "12835B01"
        , Binary.fromHex "243185BE"
        , Binary.fromHex "550C7DC3"
        , Binary.fromHex "72BE5D74"
        , Binary.fromHex "80DEB1FE"
        , Binary.fromHex "9BDC06A7"
        , Binary.fromHex "C19BF174"
        , Binary.fromHex "E49B69C1"
        , Binary.fromHex "EFBE4786"
        , Binary.fromHex "0FC19DC6"
        , Binary.fromHex "240CA1CC"
        , Binary.fromHex "2DE92C6F"
        , Binary.fromHex "4A7484AA"
        , Binary.fromHex "5CB0A9DC"
        , Binary.fromHex "76F988DA"
        , Binary.fromHex "983E5152"
        , Binary.fromHex "A831C66D"
        , Binary.fromHex "B00327C8"
        , Binary.fromHex "BF597FC7"
        , Binary.fromHex "C6E00BF3"
        , Binary.fromHex "D5A79147"
        , Binary.fromHex "06CA6351"
        , Binary.fromHex "14292967"
        , Binary.fromHex "27B70A85"
        , Binary.fromHex "2E1B2138"
        , Binary.fromHex "4D2C6DFC"
        , Binary.fromHex "53380D13"
        , Binary.fromHex "650A7354"
        , Binary.fromHex "766A0ABB"
        , Binary.fromHex "81C2C92E"
        , Binary.fromHex "92722C85"
        , Binary.fromHex "A2BFE8A1"
        , Binary.fromHex "A81A664B"
        , Binary.fromHex "C24B8B70"
        , Binary.fromHex "C76C51A3"
        , Binary.fromHex "D192E819"
        , Binary.fromHex "D6990624"
        , Binary.fromHex "F40E3585"
        , Binary.fromHex "106AA070"
        , Binary.fromHex "19A4C116"
        , Binary.fromHex "1E376C08"
        , Binary.fromHex "2748774C"
        , Binary.fromHex "34B0BCB5"
        , Binary.fromHex "391C0CB3"
        , Binary.fromHex "4ED8AA4A"
        , Binary.fromHex "5B9CCA4F"
        , Binary.fromHex "682E6FF3"
        , Binary.fromHex "748F82EE"
        , Binary.fromHex "78A5636F"
        , Binary.fromHex "84C87814"
        , Binary.fromHex "8CC70208"
        , Binary.fromHex "90BEFFFA"
        , Binary.fromHex "A4506CEB"
        , Binary.fromHex "BEF9A3F7"
        , Binary.fromHex "C67178F2"
        ]
