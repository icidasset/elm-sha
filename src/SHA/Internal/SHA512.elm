module SHA.Internal.SHA512 exposing (chunkSize, compressor, computationSetup, extender, initialHashTable, roundConstants)

import Array exposing (Array)
import Binary exposing (Bits)
import SHA.Internal.Common
import SHA.Internal.Computation as Computation
import SHA.Internal.HashTable exposing (HashTable)



-- ⚡️


chunkSize : Int
chunkSize =
    1024


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
            Binary.shiftRightZfBy 7 i15
                |> Binary.xor (Binary.rotateRightBy 8 i15)
                |> Binary.xor (Binary.rotateRightBy 1 i15)

        b =
            Binary.shiftRightZfBy 6 i2
                |> Binary.xor (Binary.rotateRightBy 61 i2)
                |> Binary.xor (Binary.rotateRightBy 19 i2)
    in
    b
        |> combine i7
        |> combine a
        |> combine i16



-- COMPRESSION


compressor : { index : Int, scheduleNumber : Bits } -> HashTable -> HashTable
compressor { index, scheduleNumber } hashTable =
    let
        -- X
        x1 =
            Binary.rotateRightBy 41 hashTable.e
                |> Binary.xor (Binary.rotateRightBy 18 hashTable.e)
                |> Binary.xor (Binary.rotateRightBy 14 hashTable.e)

        x2 =
            Binary.xor
                (Binary.and hashTable.e hashTable.f)
                (Binary.and (Binary.not hashTable.e) hashTable.g)

        x =
            scheduleNumber
                |> combine (Maybe.withDefault Binary.empty (Array.get index roundConstants))
                |> combine x2
                |> combine x1
                |> combine hashTable.h

        -- Y
        y1 =
            Binary.rotateRightBy 39 hashTable.a
                |> Binary.xor (Binary.rotateRightBy 34 hashTable.a)
                |> Binary.xor (Binary.rotateRightBy 28 hashTable.a)

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
    { a = Binary.fromHex "6A09E667F3BCC908"
    , b = Binary.fromHex "BB67AE8584CAA73B"
    , c = Binary.fromHex "3C6EF372FE94F82B"
    , d = Binary.fromHex "A54FF53A5F1D36F1"
    , e = Binary.fromHex "510E527FADE682D1"
    , f = Binary.fromHex "9B05688C2B3E6C1F"
    , g = Binary.fromHex "1F83D9ABFB41BD6B"
    , h = Binary.fromHex "5BE0CD19137E2179"
    }


roundConstants : Array Bits
roundConstants =
    Array.fromList
        [ Binary.fromHex "428A2F98D728AE22"
        , Binary.fromHex "7137449123EF65CD"
        , Binary.fromHex "B5C0FBCFEC4D3B2F"
        , Binary.fromHex "E9B5DBA58189DBBC"
        , Binary.fromHex "3956C25BF348B538"
        , Binary.fromHex "59F111F1B605D019"
        , Binary.fromHex "923F82A4AF194F9B"
        , Binary.fromHex "AB1C5ED5DA6D8118"
        , Binary.fromHex "D807AA98A3030242"
        , Binary.fromHex "12835B0145706FBE"
        , Binary.fromHex "243185BE4EE4B28C"
        , Binary.fromHex "550C7DC3D5FFB4E2"
        , Binary.fromHex "72BE5D74F27B896F"
        , Binary.fromHex "80DEB1FE3B1696B1"
        , Binary.fromHex "9BDC06A725C71235"
        , Binary.fromHex "C19BF174CF692694"
        , Binary.fromHex "E49B69C19EF14AD2"
        , Binary.fromHex "EFBE4786384F25E3"
        , Binary.fromHex "0FC19DC68B8CD5B5"
        , Binary.fromHex "240CA1CC77AC9C65"
        , Binary.fromHex "2DE92C6F592B0275"
        , Binary.fromHex "4A7484AA6EA6E483"
        , Binary.fromHex "5CB0A9DCBD41FBD4"
        , Binary.fromHex "76F988DA831153B5"
        , Binary.fromHex "983E5152EE66DFAB"
        , Binary.fromHex "A831C66D2DB43210"
        , Binary.fromHex "B00327C898FB213F"
        , Binary.fromHex "BF597FC7BEEF0EE4"
        , Binary.fromHex "C6E00BF33DA88FC2"
        , Binary.fromHex "D5A79147930AA725"
        , Binary.fromHex "06CA6351E003826F"
        , Binary.fromHex "142929670A0E6E70"
        , Binary.fromHex "27B70A8546D22FFC"
        , Binary.fromHex "2E1B21385C26C926"
        , Binary.fromHex "4D2C6DFC5AC42AED"
        , Binary.fromHex "53380D139D95B3DF"
        , Binary.fromHex "650A73548BAF63DE"
        , Binary.fromHex "766A0ABB3C77B2A8"
        , Binary.fromHex "81C2C92E47EDAEE6"
        , Binary.fromHex "92722C851482353B"
        , Binary.fromHex "A2BFE8A14CF10364"
        , Binary.fromHex "A81A664BBC423001"
        , Binary.fromHex "C24B8B70D0F89791"
        , Binary.fromHex "C76C51A30654BE30"
        , Binary.fromHex "D192E819D6EF5218"
        , Binary.fromHex "D69906245565A910"
        , Binary.fromHex "F40E35855771202A"
        , Binary.fromHex "106AA07032BBD1B8"
        , Binary.fromHex "19A4C116B8D2D0C8"
        , Binary.fromHex "1E376C085141AB53"
        , Binary.fromHex "2748774CDF8EEB99"
        , Binary.fromHex "34B0BCB5E19B48A8"
        , Binary.fromHex "391C0CB3C5C95A63"
        , Binary.fromHex "4ED8AA4AE3418ACB"
        , Binary.fromHex "5B9CCA4F7763E373"
        , Binary.fromHex "682E6FF3D6B2B8A3"
        , Binary.fromHex "748F82EE5DEFB2FC"
        , Binary.fromHex "78A5636F43172F60"
        , Binary.fromHex "84C87814A1F0AB72"
        , Binary.fromHex "8CC702081A6439EC"
        , Binary.fromHex "90BEFFFA23631E28"
        , Binary.fromHex "A4506CEBDE82BDE9"
        , Binary.fromHex "BEF9A3F7B2C67915"
        , Binary.fromHex "C67178F2E372532B"
        , Binary.fromHex "CA273ECEEA26619C"
        , Binary.fromHex "D186B8C721C0C207"
        , Binary.fromHex "EADA7DD6CDE0EB1E"
        , Binary.fromHex "F57D4F7FEE6ED178"
        , Binary.fromHex "06F067AA72176FBA"
        , Binary.fromHex "0A637DC5A2C898A6"
        , Binary.fromHex "113F9804BEF90DAE"
        , Binary.fromHex "1B710B35131C471B"
        , Binary.fromHex "28DB77F523047D84"
        , Binary.fromHex "32CAAB7B40C72493"
        , Binary.fromHex "3C9EBE0A15C9BEBC"
        , Binary.fromHex "431D67C49C100D4C"
        , Binary.fromHex "4CC5D4BECB3E42B6"
        , Binary.fromHex "597F299CFC657E2A"
        , Binary.fromHex "5FCB6FAB3AD6FAEC"
        , Binary.fromHex "6C44198C4A475817"
        ]
