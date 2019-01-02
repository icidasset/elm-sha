# SHA

An implementation of several [SHA](https://en.wikipedia.org/wiki/Secure_Hash_Algorithms) cryptographic hash functions.  
This package uses [icidasset/elm-binary](https://package.elm-lang.org/packages/icidasset/elm-binary/latest/), which can easily be converted to something else.

Currently implements:
- SHA224
- SHA256
- SHA384
- SHA512

```elm
import Binary
import SHA

>>> "abc"
..>   |> SHA.sha256
..>   |> Binary.toHex
"BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD"
```
