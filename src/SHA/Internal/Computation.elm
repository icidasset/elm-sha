module SHA.Internal.Computation exposing (Setup)

import Array exposing (Array)
import Binary exposing (Bits)
import SHA.Internal.HashTable exposing (HashTable)



-- COMPUTATION


type alias Setup =
    { extender : { i2 : Bits, i7 : Bits, i15 : Bits, i16 : Bits } -> Bits
    , compressor : { index : Int, scheduleNumber : Bits } -> HashTable -> HashTable

    -- Constants
    , chunkSize : Int
    , initialHashTable : HashTable
    , roundConstants : Array Bits
    }
