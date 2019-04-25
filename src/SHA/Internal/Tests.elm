module SHA.Internal.Tests exposing (sha224, sha256, sha384, sha512)

{-| Tests.

    >>> import Binary

-}

import SHA


{-| SHA-224 tests.

    >>> "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha224
    ..>   |> Binary.toHex
    "75388B16512776CC5DBA5DA1FD890150B0C6455CB4F58B1952522525"

    >>> "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha224
    ..>   |> Binary.toHex
    "C97CA9A559850CE97A04A96DEF6D99A9E0E0E2AB14E6B8DF265FC0B3"

    >>> "a"
    ..>   |> String.repeat 10000
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha224
    ..>   |> Binary.toHex
    "00568FBA93E8718C2F7DCD82FA94501D59BB1BBCBA2C7DC2BA5882DB"

-}
sha224 =
    SHA.sha224


{-| SHA-256 tests.

    >>> "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha256
    ..>   |> Binary.toHex
    "248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1"

    >>> "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha256
    ..>   |> Binary.toHex
    "CF5B16A778AF8380036CE59E7B0492370B249B11E8F07A51AFAC45037AFEE9D1"

    >>> "a"
    ..>   |> String.repeat 10000
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha256
    ..>   |> Binary.toHex
    "27DD1F61B867B6A0F6E9D8A41C43231DE52107E53AE424DE8F847B821DB4B711"

-}
sha256 =
    SHA.sha256


{-| SHA-384 tests.

    >>> "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha384
    ..>   |> Binary.toHex
    "3391FDDDFC8DC7393707A65B1B4709397CF8B1D162AF05ABFE8F450DE5F36BC6B0455A8520BC4E6F5FE95B1FE3C8452B"

    >>> "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha384
    ..>   |> Binary.toHex
    "09330C33F71147E83D192FC782CD1B4753111B173B3B05D22FA08086E3B0F712FCC7C71A557E2DB966C3E9FA91746039"

    >>> "a"
    ..>   |> String.repeat 10000
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha384
    ..>   |> Binary.toHex
    "2BCA3B131BB7E922BCD1DE98C44786D32E6B6B2993E69C4987EDF9DD49711EB501F0E98AD248D839F6BF9E116E25A97C"

-}
sha384 =
    SHA.sha384


{-| SHA-512 tests.

    >>> "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha512
    ..>   |> Binary.toHex
    "204A8FC6DDA82F0A0CED7BEB8E08A41657C16EF468B228A8279BE331A703C33596FD15C13B1B07F9AA1D3BEA57789CA031AD85C7A71DD70354EC631238CA3445"

    >>> "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha512
    ..>   |> Binary.toHex
    "8E959B75DAE313DA8CF4F72814FC143F8F7779C6EB9F7FA17299AEADB6889018501D289E4900F7E4331B99DEC4B5433AC7D329EEB6DD26545E96E55B874BE909"

    >>> "a"
    ..>   |> String.repeat 10000
    ..>   |> Binary.fromStringAsUtf8
    ..>   |> sha512
    ..>   |> Binary.toHex
    "0593036F4F479D2EB8078CA26B1D59321A86BDFCB04CB40043694F1EB0301B8ACD20B936DB3C916EBCC1B609400FFCF3FA8D569D7E39293855668645094BAF0E"

-}
sha512 =
    SHA.sha512
