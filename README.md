# SHA

An implementation of several [SHA](https://en.wikipedia.org/wiki/Secure_Hash_Algorithms) cryptographic hash functions. Uses [icidasset/elm-binary](https://package.elm-lang.org/packages/icidasset/elm-binary/latest/) underneath and as output, which can be converted to something else.

```elm
import Binary
import SHA

>>> "abc"
..>   |> SHA.sha256
..>   |> Binary.toHex
"BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD"
```


## TODO / Warning

There's currently a performance penalty when the message is over 600 characters long.
