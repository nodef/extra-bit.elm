The bit is a basic unit of information in information theory, computing.<br>
:package: [Package](https://package.elm-lang.org/packages/elmw/extra-bit/latest/),
:blue_book: [Wiki](https://github.com/elmw/extra-bit/wiki).

<br>

This package includes [bit twiddling hacks] by Sean Eron Anderson and many others.

> Stability: Experimental.

[bit]: https://en.wikipedia.org/wiki/Bit
[bit twiddling hacks]: https://graphics.stanford.edu/~seander/bithacks.html

<br>

```elm
import Bit exposing (..)

count 7
-- 3 (111 => 3)

parity 8 2
-- 2 (10,00 => 10)

swap 6 1 0 1
-- 5 (110 => 101)

reverse 0xFFFF0000
-- 65535 (0x0000FFFF)

signExtend 15 4
-- -1
```

<br>
<br>


## Index

| Method       | Action                                  |
| ------------ | --------------------------------------- |
| [get]        | Get a bit.                              |
| [set]        | Set a bit.                              |
| [toggle]     | Toggle a bit.                           |
| [swap]       | Swap bit sequences.                     |
| [scan]       | Get index of first set bit from LSB.    |
| [count]      | Count bits set.                         |
| [parity]     | Get n-bit parity.                       |
| [rotate]     | Rotate bits.                            |
| [reverse]    | Reverse all bits.                       |
| [merge]      | Merge bits as per mask.                 |
| [interleave] | Interleave bits of two int16s.          |
| [signExtend] | Sign extend variable bit-width integer. |

[get]: https://github.com/elmw/extra-bit/wiki/get
[set]: https://github.com/elmw/extra-bit/wiki/set
[setAs]: https://github.com/elmw/extra-bit/wiki/setAs
[swap]: https://github.com/elmw/extra-bit/wiki/swap
[scan]: https://github.com/elmw/extra-bit/wiki/scan
[scanReverse]: https://github.com/elmw/extra-bit/wiki/scanReverse
[count]: https://github.com/elmw/extra-bit/wiki/count
[parity]: https://github.com/elmw/extra-bit/wiki/parity
[reverse]: https://github.com/elmw/extra-bit/wiki/reverse
[merge]: https://github.com/elmw/extra-bit/wiki/merge
[interleave]: https://github.com/elmw/extra-bit/wiki/interleave
[signExtend]: https://github.com/elmw/extra-bit/wiki/signExtend
[toggle]: https://github.com/elmw/extra-bit/wiki/toggle
[rotate]: https://github.com/elmw/extra-bit/wiki/rotate

<br>
<br>

[![](https://img.youtube.com/vi/4_zSIXb7tLQ/maxresdefault.jpg)](https://www.youtube.com/watch?v=4_zSIXb7tLQ)
