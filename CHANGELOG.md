# Changelog


#### 2.0.0

The hash functions now take `Binary.Bits` instead of `String`s.
The reason for this is that the strings were always converted
to UTF-8 by this package. But there might be cases where we
don't want UTF-8 strings as the input (eg. HMAC).


#### 1.0.2

Upgrade `elm-binary`.


#### 1.0.1

- Performance improvements.
- Fixed text-encoding issue.
