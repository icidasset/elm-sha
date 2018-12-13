module SHA exposing (sha224, sha256, sha384, sha512)

{-| An implementation of several [SHA](https://en.wikipedia.org/wiki/Secure_Hash_Algorithms) cryptographic hash functions. Uses [icidasset/elm-binary](https://package.elm-lang.org/packages/icidasset/elm-binary/latest/) underneath and as output, which can be converted to something else.

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


    >>> Binary.toHex (sha224 "")
    "D14A028C2A3A2BC9476102BB288234C415A2B01F828EA62AC5B3E42F"

    >>> Binary.toHex (sha224 "abc")
    "23097D223405D8228642A477BDA255B32AADBCE4BDA0B3F7E36C9DA7"

    >>> Binary.toHex (sha224 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
    "75388B16512776CC5DBA5DA1FD890150B0C6455CB4F58B1952522525"

    >>> Binary.toHex (sha224 "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu")
    "C97CA9A559850CE97A04A96DEF6D99A9E0E0E2AB14E6B8DF265FC0B3"

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


{-| SHA-384.

    >>> import Binary

    >>> Binary.toHex (sha384 "")
    "38B060A751AC96384CD9327EB1B1E36A21FDB71114BE07434C0CC7BF63F6E1DA274EDEBFE76F65FBD51AD2F14898B95B"

    >>> Binary.toHex (sha384 "abc")
    "CB00753F45A35E8BB5A03D699AC65007272C32AB0EDED1631A8B605A43FF5BED8086072BA1E7CC2358BAECA134C825A7"

    >>> Binary.toHex (sha384 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
    "3391FDDDFC8DC7393707A65B1B4709397CF8B1D162AF05ABFE8F450DE5F36BC6B0455A8520BC4E6F5FE95B1FE3C8452B"

    >>> Binary.toHex (sha384 "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu")
    "09330C33F71147E83D192FC782CD1B4753111B173B3B05D22FA08086E3B0F712FCC7C71A557E2DB966C3E9FA91746039"

-}
sha384 : String -> Bits
sha384 message =
    message
        |> preprocess { blockLength = 1024 }
        |> compute SHA.Internal.SHA384.computationSetup
        |> partialHashTableToBits [ .a, .b, .c, .d, .e, .f ]


{-| SHA-512.

    >>> import Binary

    >>> Binary.toHex (sha512 "")
    "CF83E1357EEFB8BDF1542850D66D8007D620E4050B5715DC83F4A921D36CE9CE47D0D13C5D85F2B0FF8318D2877EEC2F63B931BD47417A81A538327AF927DA3E"

    >>> Binary.toHex (sha512 "abc")
    "DDAF35A193617ABACC417349AE20413112E6FA4E89A97EA20A9EEEE64B55D39A2192992A274FC1A836BA3C23A3FEEBBD454D4423643CE80E2A9AC94FA54CA49F"

    >>> Binary.toHex (sha512 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
    "204A8FC6DDA82F0A0CED7BEB8E08A41657C16EF468B228A8279BE331A703C33596FD15C13B1B07F9AA1D3BEA57789CA031AD85C7A71DD70354EC631238CA3445"

    >>> Binary.toHex (sha512 "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu")
    "8E959B75DAE313DA8CF4F72814FC143F8F7779C6EB9F7FA17299AEADB6889018501D289E4900F7E4331B99DEC4B5433AC7D329EEB6DD26545E96E55B874BE909"

-}
sha512 : String -> Bits
sha512 message =
    message
        |> preprocess { blockLength = 1024 }
        |> compute SHA.Internal.SHA512.computationSetup
        |> hashTableToBits
