module SHA.Internal.Common exposing (combine)

import Binary exposing (Bits)
import List.Extra as List
import SHA.Internal.Binary as Binary



-- MATHS


{-| Addition modulo.

    Sums up all the given binary sequences,
    and if the decimal value is greater than `2 ^ sizeInBits`,
    `2 ^ sizeInBits` is subtracted from the sum.

    >>> import Binary
    >>> smaller     = Binary.fromDecimal (2 ^ 32 - 1)
    >>> max         = Binary.fromDecimal (2 ^ 32)
    >>> larger      = Binary.fromDecimal (2 ^ 32 + 1)
    >>> zero        = Binary.fromBooleans []
    >>> one         = Binary.fromDecimal 1
    >>> two         = Binary.fromDecimal 2

    >>> Binary.dropLeadingZeros <| combine 32 [ smaller ]
    smaller

    >>> Binary.dropLeadingZeros <| combine 32 [ smaller, one ]
    zero

    >>> Binary.dropLeadingZeros <| combine 32 [ max ]
    zero

    >>> Binary.dropLeadingZeros <| combine 32 [ larger ]
    one

    >>> Binary.dropLeadingZeros <| combine 32 [ larger, one ]
    two

-}
combine : Int -> List Bits -> Bits
combine sizeInBits bitsList =
    bitsList
        |> List.foldl1
            (\x y ->
                let
                    sum =
                        Binary.add x y
                in
                if List.length (Binary.toBooleans sum) > sizeInBits then
                    -- Is the sum larger than the modulo constant (ie. 2 ^ sizeInBits)?
                    Binary.subtract
                        sum
                        (Binary.fromBooleans (True :: List.repeat sizeInBits False))

                else
                    -- If not, carry on.
                    sum
            )
        |> Maybe.withDefault Binary.empty
        |> Binary.dropLeadingZeros
        |> Binary.ensureBits sizeInBits
