module SHA.Internal.SHA384 exposing (computationSetup, initialHashTable)

import Binary exposing (Bits)
import SHA.Internal.Computation as Computation
import SHA.Internal.HashTable exposing (HashTable)
import SHA.Internal.SHA512



-- ⚡️


computationSetup : Computation.Setup
computationSetup =
    { extender = SHA.Internal.SHA512.extender
    , compressor = SHA.Internal.SHA512.compressor

    -- Constants
    , chunkSize = SHA.Internal.SHA512.chunkSize
    , initialHashTable = initialHashTable
    , roundConstants = SHA.Internal.SHA512.roundConstants
    }



-- CONSTANTS


initialHashTable : HashTable
initialHashTable =
    { a = Binary.fromHex "CBBB9D5DC1059ED8"
    , b = Binary.fromHex "629A292A367CD507"
    , c = Binary.fromHex "9159015A3070DD17"
    , d = Binary.fromHex "152FECD8F70E5939"
    , e = Binary.fromHex "67332667FFC00B31"
    , f = Binary.fromHex "8EB44A8768581511"
    , g = Binary.fromHex "DB0C2E0D64F98FA7"
    , h = Binary.fromHex "47B5481DBEFA4FA4"
    }
