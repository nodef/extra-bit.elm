The bit is a basic unit of information in information theory, computing.<br>
:package: [Package](https://package.elm-lang.org/packages/elmw/extra-bit/latest/).

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

swap 6 1 0
-- 5 (110 => 101)

reverse 0xFFFF0000
-- 65535 (0x0000FFFF)

signExtend 15 4
-- -1
```

<br>
<br>


## Index

| Method       | Action                                   |
| ------------ | ---------------------------------------- |
| [get]        | Gets a bit.                              |
| [set]        | Sets a bit.                              |
| [toggle]     | Toggles a bit.                           |
| [swap]       | Swaps bit sequences.                     |
| [scan]       | Gets index of first set bit from LSB.    |
| [count]      | Counts bits set.                         |
| [parity]     | Gets n-bit parity.                       |
| [rotate]     | Rotates bits.                            |
| [reverse]    | Reverses all bits.                       |
| [merge]      | Merges bits as per mask.                 |
| [interleave] | Interleaves bits of two int16s.          |
| [signExtend] | Sign extends variable bit-width integer. |


[get]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#get
[set]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#set
[setAs]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#setAs
[swap]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#swap
[scan]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#scan
[scanReverse]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#scanReverse
[count]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#count
[parity]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#parity
[reverse]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#reverse
[merge]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#merge
[interleave]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#interleave
[signExtend]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#signExtend
[toggle]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#toggle
[rotate]: https://package.elm-lang.org/packages/elmw/extra-bit/latest/Bit#rotate

<br>
<br>

[![](https://img.youtube.com/vi/plcc6E-E1uU/maxresdefault.jpg)](https://www.youtube.com/watch?v=plcc6E-E1uU)
