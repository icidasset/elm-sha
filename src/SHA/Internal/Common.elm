module SHA.Internal.Common exposing (combine)

import Binary exposing (Bits)



-- MATHS


{-| Addition modulo.

    Sums up all the given binary sequences,
    and if the decimal value is greater than `2 ^ sizeInBits`,
    `2 ^ sizeInBits` is subtracted from the sum.

    >>> import Binary
    >>> smaller     = Binary.fromDecimal (2 ^ 32 - 1)
    >>> max         = Binary.fromDecimal (2 ^ 32)
    >>> larger      = Binary.fromDecimal (2 ^ 32 + 1)
    >>> zero        = Binary.empty
    >>> one         = Binary.fromDecimal 1
    >>> two         = Binary.fromDecimal 2
    >>> fifteen     = Binary.fromDecimal 15

    >>> Binary.dropLeadingZeros <| combine 32 smaller zero
    smaller

    >>> Binary.dropLeadingZeros <| combine 32 smaller one
    zero

    >>> Binary.dropLeadingZeros <| combine 32 max zero
    zero

    >>> Binary.dropLeadingZeros <| combine 32 larger zero
    one

    >>> Binary.dropLeadingZeros <| combine 32 larger one
    two

    >>> combine 4 (Binary.fromDecimal (2 ^ 16)) fifteen
    fifteen

    >>> combine 4 fifteen (Binary.fromDecimal (2 ^ 16))
    fifteen

-}
combine : Int -> Bits -> Bits -> Bits
combine sizeInBits x y =
    let
        sum =
            Binary.dropLeadingZeros (Binary.add x y)

        width =
            Binary.width sum
    in
    if width > sizeInBits then
        let
            excess =
                width - sizeInBits
        in
        -- Is the sum larger than the modulo constant (ie. 2 ^ sizeInBits)?
        sum
            |> Binary.toBooleans
            |> List.drop excess
            |> Binary.fromBooleans
            |> Binary.dropLeadingZeros
            |> Binary.ensureSize sizeInBits

    else
        -- If not, carry on.
        Binary.ensureSize sizeInBits sum
