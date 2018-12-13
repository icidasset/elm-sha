module SHA exposing (sha224, sha256)

{-| An implementation of several [SHA](https://en.wikipedia.org/wiki/Secure_Hash_Algorithms) cryptographic hash functions. Uses [icidasset/elm-binary](https://package.elm-lang.org/packages/icidasset/elm-binary/latest/) underneath and as output, which can be converted to something else.

@docs sha224, sha256

-}

import Binary exposing (Bits)
import SHA.Internal exposing (compute, preprocess)
import SHA.Internal.HashTable exposing (..)
import SHA.Internal.SHA224
import SHA.Internal.SHA256


{-| SHA-224.

    >>> import Binary


    >>> Binary.toHex (sha224 "")
    "D14A028C2A3A2BC9476102BB288234C415A2B01F828EA62AC5B3E42F"

    >>> Binary.toHex (sha224 "abc")
    "23097D223405D8228642A477BDA255B32AADBCE4BDA0B3F7E36C9DA7"

-}
sha224 : String -> Bits
sha224 message =
    message
        |> preprocess { blockLength = 512 }
        |> compute SHA.Internal.SHA224.computationSetup
        |> partialHashTableToBits [ .a, .b, .c, .d, .e, .f, .g ]


{-| SHA-256.

    >>> import Binary


    >>> Binary.toHex (sha256 "")
    "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855"

    >>> Binary.toHex (sha256 "abc")
    "BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD"

    >>> Binary.toHex (sha256 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
    "248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1"

    >>> Binary.toHex (sha256 "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu")
    "CF5B16A778AF8380036CE59E7B0492370B249B11E8F07A51AFAC45037AFEE9D1"

-}
sha256 : String -> Bits
sha256 message =
    message
        |> preprocess { blockLength = 512 }
        |> compute SHA.Internal.SHA256.computationSetup
        |> hashTableToBits
