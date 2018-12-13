module SHA.Internal exposing (compress, compute, computeChunk, extend, extendInitialSchedule, preprocess)

import Array exposing (Array)
import Binary exposing (Bits)
import SHA.Internal.Binary as Binary
import SHA.Internal.Common exposing (..)
import SHA.Internal.Computation as Computation
import SHA.Internal.HashTable exposing (..)



-- PRE-PROCESSING


{-| Preliminary processing, ie. adding padding to the original message.

    The pre-processed message must be a multiple of 512 bits, ie. 64 bytes.
    Padding is always added even if the original message is 512 bits.


    >>> import Binary


    ### SHA-256

    >>> ""
    ..>   |> preprocess { blockLength = 512 }
    ..>   |> Binary.width
    512

    >>> "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
    ..>   |> preprocess { blockLength = 512 }
    ..>   |> Binary.width
    1024

    >>> "abc"
    ..>   |> preprocess { blockLength = 512 }
    ..>   |> Binary.toHex
    "61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018"

    >>> "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
    ..>   |> preprocess { blockLength = 512 }
    ..>   |> Binary.toHex
    "6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001C0"


    ### SHA-512

    >>> "abc"
    ..>   |> preprocess { blockLength = 1024 }
    ..>   |> Binary.toHex
    "6162638000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018"

-}
preprocess : { blockLength : Int } -> String -> Bits
preprocess { blockLength } message =
    let
        m =
            Binary.fromString message

        -- Length of the message in bits
        l =
            Binary.width m

        -- (k + l + 1 + 64) is a multiple of `blockLength`
        --
        -- The `1` and `blockLength // 8` numbers refer to the bits that
        -- we're going to append to the message later
        k =
            blockLength - modBy blockLength (l + 1 + blockLength // 8)
    in
    [ m

    -- Append a single 1 bit (represented as a single byte)
    , Binary.fromBooleans [ True ]

    -- Append k 0 bits
    , False
        |> List.repeat k
        |> Binary.fromBooleans

    -- Append l as a x-bit big-endian integer
    , l
        |> Binary.fromDecimal
        |> Binary.ensureBits (blockLength // 8)
    ]
        |> Binary.concat



-- COMPUTATION


{-| Break padded-message in chunks,
and then process each chunk.
-}
compute : Computation.Setup -> Bits -> HashTable
compute setup bits =
    bits
        |> Binary.chunksOf setup.chunkSize
        |> List.foldl (computeChunk setup) setup.initialHashTable


{-| Break each chunk in words (ie. smaller chunks),
and then go through the different computation steps.
-}
computeChunk : Computation.Setup -> Bits -> HashTable -> HashTable
computeChunk setup bits hashTable =
    bits
        |> Binary.chunksOf (setup.chunkSize // 16)
        |> Array.fromList
        |> extendInitialSchedule setup
        |> Array.toIndexedList
        |> compress setup hashTable



-- (1) EXTEND


{-| Build a fully-sized message-schedule,
based on a given initial schedule.
-}
extendInitialSchedule : Computation.Setup -> Array Bits -> Array Bits
extendInitialSchedule setup initialSchedule =
    let
        scheduleSize =
            Array.length setup.roundConstants - 1

        lengthySchedule =
            Array.append
                initialSchedule
                (Array.repeat (scheduleSize - 15) Binary.empty)
    in
    Array.foldl
        (extend setup)
        lengthySchedule
        (scheduleSize
            |> List.range 16
            |> Array.fromList
        )


extend : Computation.Setup -> Int -> Array Bits -> Array Bits
extend setup index schedule =
    Maybe.map4
        (\i2 i7 i15 i16 -> setup.extender { i2 = i2, i7 = i7, i15 = i15, i16 = i16 })
        (Array.get (index - 2) schedule)
        (Array.get (index - 7) schedule)
        (Array.get (index - 15) schedule)
        (Array.get (index - 16) schedule)
        |> Maybe.map (\bits -> Array.set index bits schedule)
        |> Maybe.withDefault schedule



-- (2) COMPRESSION


type alias Compressor =
    { index : Int, scheduleNumber : Bits } -> HashTable -> HashTable


{-| Take a set of hash values and run the compression function on it.
-}
compress : Computation.Setup -> HashTable -> List ( Int, Bits ) -> HashTable
compress setup hashTable schedule =
    schedule
        |> List.foldl (useCompressor setup.compressor) hashTable
        |> combineHashTables (setup.chunkSize // 16) hashTable


useCompressor : Compressor -> ( Int, Bits ) -> HashTable -> HashTable
useCompressor compressor ( index, scheduleNumber ) =
    compressor { index = index, scheduleNumber = scheduleNumber }
