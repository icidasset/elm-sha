module SHA.Internal.SHA224 exposing (computationSetup, initialHashTable)

import Binary
import SHA.Internal.Computation as Computation
import SHA.Internal.HashTable exposing (HashTable)
import SHA.Internal.SHA256



-- ⚡️


computationSetup : Computation.Setup
computationSetup =
    { extender = SHA.Internal.SHA256.extender
    , compressor = SHA.Internal.SHA256.compressor

    -- Constants
    , chunkSize = SHA.Internal.SHA256.chunkSize
    , initialHashTable = initialHashTable
    , roundConstants = SHA.Internal.SHA256.roundConstants
    }



-- CONSTANTS


initialHashTable : HashTable
initialHashTable =
    { a = Binary.fromHex "C1059ED8"
    , b = Binary.fromHex "367CD507"
    , c = Binary.fromHex "3070DD17"
    , d = Binary.fromHex "F70E5939"
    , e = Binary.fromHex "FFC00B31"
    , f = Binary.fromHex "68581511"
    , g = Binary.fromHex "64F98FA7"
    , h = Binary.fromHex "BEFA4FA4"
    }
