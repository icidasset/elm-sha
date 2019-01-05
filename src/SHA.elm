module SHA exposing (sha224, sha256, sha384, sha512)

{-| An implementation of several [SHA](https://en.wikipedia.org/wiki/Secure_Hash_Algorithms) cryptographic hash functions. This package uses [icidasset/elm-binary](https://package.elm-lang.org/packages/icidasset/elm-binary/latest/) to work with binary numbers.

@docs sha224, sha256, sha384, sha512

-}

import Binary exposing (Bits)
import SHA.Internal exposing (compute, preprocess)
import SHA.Internal.HashTable exposing (..)
import SHA.Internal.SHA224
import SHA.Internal.SHA256
import SHA.Internal.SHA384
import SHA.Internal.SHA512


{-| SHA-224.

    >>> import Binary

    >>> "abc"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> SHA.sha224
    ..>   |> Binary.toHex
    "23097D223405D8228642A477BDA255B32AADBCE4BDA0B3F7E36C9DA7"

    >>> "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> SHA.sha224
    ..>   |> Binary.toHex
    "C97CA9A559850CE97A04A96DEF6D99A9E0E0E2AB14E6B8DF265FC0B3"

-}
sha224 : Bits -> Bits
sha224 message =
    message
        |> preprocess { blockLength = 512 }
        |> compute SHA.Internal.SHA224.computationSetup
        |> partialHashTableToBits [ .a, .b, .c, .d, .e, .f, .g ]


{-| SHA-256.

    >>> import Binary

    >>> "abc"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> SHA.sha256
    ..>   |> Binary.toHex
    "BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD"

    >>> "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> SHA.sha256
    ..>   |> Binary.toHex
    "CF5B16A778AF8380036CE59E7B0492370B249B11E8F07A51AFAC45037AFEE9D1"

-}
sha256 : Bits -> Bits
sha256 message =
    message
        |> preprocess { blockLength = 512 }
        |> compute SHA.Internal.SHA256.computationSetup
        |> hashTableToBits


{-| SHA-384.

    >>> import Binary

    >>> "abc"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> SHA.sha384
    ..>   |> Binary.toHex
    "CB00753F45A35E8BB5A03D699AC65007272C32AB0EDED1631A8B605A43FF5BED8086072BA1E7CC2358BAECA134C825A7"

    >>> "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> SHA.sha384
    ..>   |> Binary.toHex
    "09330C33F71147E83D192FC782CD1B4753111B173B3B05D22FA08086E3B0F712FCC7C71A557E2DB966C3E9FA91746039"

-}
sha384 : Bits -> Bits
sha384 message =
    message
        |> preprocess { blockLength = 1024 }
        |> compute SHA.Internal.SHA384.computationSetup
        |> partialHashTableToBits [ .a, .b, .c, .d, .e, .f ]


{-| SHA-512.

    >>> import Binary

    >>> "abc"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> SHA.sha512
    ..>   |> Binary.toHex
    "DDAF35A193617ABACC417349AE20413112E6FA4E89A97EA20A9EEEE64B55D39A2192992A274FC1A836BA3C23A3FEEBBD454D4423643CE80E2A9AC94FA54CA49F"

    >>> "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> SHA.sha512
    ..>   |> Binary.toHex
    "8E959B75DAE313DA8CF4F72814FC143F8F7779C6EB9F7FA17299AEADB6889018501D289E4900F7E4331B99DEC4B5433AC7D329EEB6DD26545E96E55B874BE909"

-}
sha512 : Bits -> Bits
sha512 message =
    message
        |> preprocess { blockLength = 1024 }
        |> compute SHA.Internal.SHA512.computationSetup
        |> hashTableToBits
