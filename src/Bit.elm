module Bit exposing (
    count, get, getAs, interleave, merge, parity, reverse, rotate,
    scan, scanReverse, set, setAs, signExtend, swap, toggle, toggleAs
  )
{-|
The bit is a basic unit of information in information theory, computing.
This package includes bit twiddling hacks by Sean Eron Anderson and many
others.\
📦 [Package](https://package.elm-lang.org/packages/elmw/extra-boolean/latest/),
📘 [Wiki](https://github.com/elmw/extra-boolean/wiki).

@docs count, get, getAs, interleave, merge, parity, reverse, rotate
@docs scan, scanReverse, set, setAs, signExtend, swap, toggle, toggleAs
-}

import Basics exposing (remainderBy)
import Array exposing (Array, fromList)
import Bitwise exposing (and, or, complement, shiftLeftBy, shiftRightZfBy)
import Bitwise exposing (shiftRightBy)




-- CONSTANTS
debruijnPos32 : Array Int
debruijnPos32 = fromList [
    0,  9,  1, 10, 13, 21,  2, 29, 11, 14, 16, 18, 22, 25,  3, 30,
    8, 12, 20, 28, 15, 17, 24,  7, 19, 27, 23,  6, 26,  5,  4, 31
  ]

mod37Pos32 : Array Int
mod37Pos32 = fromList [
    32, 0, 1, 26, 2, 23, 27, 0, 3, 16, 24, 30, 28, 11, 0, 13, 4, 7, 17, 0,
    25, 22, 31, 15, 29, 10, 12, 6, 0, 21, 14, 9, 5, 20, 8, 19, 18
  ]




-- HELPER FUNCTIONS
bxor : Int -> Int -> Int
bxor = Bitwise.xor

arrayGet : d -> Int -> Array d -> d
arrayGet d i x =
  Maybe.withDefault d (Array.get i x)




-- GET*, SET*, TOGGLE*, SWAP
{-|
Get a bit.
[📘](https://github.com/elmw/extra-boolean/wiki/get)

    -- x: an Int
    -- i: bit index
    get 6 0 == 0 (110,0 => 0)
    get 6 1 == 1 (110,1 => 1)
    get 6 2 == 1 (110,2 => 1)
-}
get : Int -> Int -> Int
get x i =
  and (shiftRightZfBy i x) 1


{-|
Get bits as per mask.
[📘](https://github.com/elmw/extra-boolean/wiki/getAs)

    -- x: an Int
    -- m: bit mask
    getAs 6 4 == 4 (110,100 => 100)
    getAs 6 7 == 6 (110,111 => 110)
    getAs 6 5 == 4 (110,101 => 100)
-}
getAs : Int -> Int -> Int
getAs x m =
  and x m


{-|
Set a bit.
[📘](https://github.com/elmw/extra-boolean/wiki/set)

    -- x: an Int
    -- i: bit index
    -- f: bit value (1)
    set 6 0 1 == 7 (110,0,1 => 111)
    set 6 2 1 == 6 (110,2,1 => 110)
    set 6 2 0 == 2 (110,2,0 => 010)
-}
set : Int -> Int -> Int -> Int
set x i f =
  or (and x (complement (shiftLeftBy i 1))) (shiftLeftBy i f)


{-|
Set bits as per mask.
[📘](https://github.com/elmw/extra-boolean/wiki/setAs)

    -- x: an Int
    -- m: bit mask
    -- f: bit value (1)
    setAs 8 2 1          == 10   (0x8 set 0x2      => 0xA)
    setAs 15 3 0         == 12   (0xF clear 0x3    => 0xC)
    setAs 0x1234 0x430 1 == 5684 (0x1234 set 0x430 => 0x1634)
-}
setAs : Int -> Int -> Int -> Int
setAs x m f =
  or (and x (complement m)) (and (-f) m)


{-|
Toggle a bit.
[📘](https://github.com/elmw/extra-boolean/wiki/toggle)

    -- x: an Int
    -- i: bit index
    toggle 6 0 == 7 (110,0 => 111)
    toggle 6 1 == 4 (110,1 => 100)
    toggle 6 2 == 2 (110,2 => 010)
-}
toggle : Int -> Int -> Int
toggle x i =
  bxor x (shiftLeftBy i 1)


{-|
Toggle bits as per mask.
[📘](https://github.com/elmw/extra-boolean/wiki/toggleAs)

    -- x: an Int
    -- m: bit mask
    toggleAs 6 1 == 7 (110,000 => 111)
    toggleAs 6 7 == 1 (110,111 => 001)
    toggleAs 6 3 == 5 (110,011 => 101)
-}
toggleAs : Int -> Int -> Int
toggleAs x m =
  bxor x m


{-|
Swap bit sequences.
[📘](https://github.com/elmw/extra-boolean/wiki/swap)

    -- x: an Int
    -- i: first bit index
    -- j: second bit index
    -- n: bit width (1)
    swap 6 1 0 1      == 5     (110    => 101)
    swap 0x1234 8 4 4 == 4900  (0x1234 => 0x1324)
    swap 0x4AAB 8 0 8 == 43850 (0x4AAB => 0xAB4A)
-}
swap : Int -> Int -> Int -> Int -> Int
swap x i j n =
  let t = and (bxor (shiftRightZfBy i x) (shiftRightZfBy j x)) ((shiftLeftBy n 1) - 1) in
  bxor x (or (shiftLeftBy i t) (shiftLeftBy j t))




-- COUNT, PARITY, SCAN*
{-|
Count bits set.
[📘](https://github.com/elmw/extra-boolean/wiki/count)

    -- x: an Int
    count 7  == 3 (111    => 3)
    count 12 == 2 (1100   => 2)
    count 63 == 6 (111111 => 6)
-}
count : Int -> Int
count x =
  let a = x - (and (shiftRightZfBy 1 x) 0x55555555)
      b = (and a 0x33333333) + (and (shiftRightZfBy 2 a) 0x33333333) in
  shiftRightZfBy 24 ((and (b + (shiftRightZfBy 4 b)) 0x0F0F0F0F) * 0x01010101)


{-|
Get n-bit parity.
[📘](https://github.com/elmw/extra-boolean/wiki/parity)

    -- x: an Int
    -- n: number of bits (1)
    parity 7 1  == 1  (1,1,1   => 1)
    parity 5 1  == 0  (1,0,1   => 0)
    parity 8 2  == 2  (10,00   => 10)
    parity 63 4 == 12 (11,1111 => 1100)
-}
parity : Int -> Int -> Int
parity x n =
  case n of
     1 -> parity1 x
     _ -> parityLoop 0 x n ((shiftLeftBy n 1) - 1)

parity1 : Int -> Int
parity1 x =
  let a = bxor x (shiftRightZfBy 16 x)
      b = bxor a (shiftRightZfBy 8 a)
      c = bxor b (shiftRightZfBy 4 b)
      d = and c 0xF in
  and (shiftRightZfBy d 0x6996) 1

parityLoop : Int -> Int -> Int -> Int -> Int
parityLoop a x n m =
  if x == 0 then a else parityLoop (bxor a (and x m)) (shiftRightZfBy n x) n m


{-|
Get index of first set bit from LSB.
[📘](https://github.com/elmw/extra-boolean/wiki/scan)

    -- x: an Int
    scan 7  == 0 (111     => 0)
    scan 12 == 2 (1100    => 2)
    scan 64 == 6 (1000000 => 6)
-}
scan : Int -> Int
scan x =
  arrayGet 0 (remainderBy 37 (and (-x) x)) mod37Pos32


{-|
Gets index of first set bit from MSB.
[📘](https://github.com/elmw/extra-boolean/wiki/scanReverse)

    -- x: an Int
    scanReverse 13 == 3 (1101 => 3)
    scanReverse 5  == 2 (101  => 2)
    scanReverse 1  == 0 (1    => 0)
-}
scanReverse : Int -> Int
scanReverse x =
  let a = or x (shiftRightZfBy 1 x)
      b = or a (shiftRightZfBy 2 a)
      c = or b (shiftRightZfBy 4 b)
      d = or c (shiftRightZfBy 8 c)
      e = or d (shiftRightZfBy 16 d) in
  arrayGet 0 (shiftRightZfBy 27 (e*0x07C4ACDD)) debruijnPos32




-- MERGE, INTERLEAVE, ROTATE, REVERSE, SIGNEXTEND
{-|
Merge bits as per mask.
[📘](https://github.com/elmw/extra-boolean/wiki/merge)

    -- x: first Int
    -- y: second Int
    -- m: bit mask (0 => from x)
    merge 0x12 0x24 0x0F       == 20    (0x14)
    merge 0x1234 0xABCD 0x0F0F == 6973  (0x1B3D)
    merge 0xAAAA 0xBBBB 0x3333 == 48059 (0xBBBB)
-}
merge : Int -> Int -> Int -> Int
merge x y m =
  bxor x (and (bxor x y) m)


{-|
Interleave bits of two Int16s.
[📘](https://github.com/elmw/extra-boolean/wiki/interleave)

    -- x: first Int16
    -- y: second Int16
    interleave 0x0000 0xFFFF == 1431655765 (0x55555555)
    interleave 0x1234 0x1234 == 51121968   (0x030C0F30)
    interleave 0x1234 0x4321 == 302845473  (0x120D0E21)
-}
interleave : Int -> Int -> Int
interleave x y =
  let a = and (or x (shiftLeftBy 8 x)) 0x00FF00FF
      b = and (or a (shiftLeftBy 4 a)) 0x0F0F0F0F
      c = and (or b (shiftLeftBy 2 b)) 0x33333333
      d = and (or c (shiftLeftBy 1 c)) 0x55555555
      i = and (or y (shiftLeftBy 8 y)) 0x00FF00FF
      j = and (or i (shiftLeftBy 4 i)) 0x0F0F0F0F
      k = and (or j (shiftLeftBy 2 j)) 0x33333333
      l = and (or k (shiftLeftBy 1 k)) 0x55555555 in
  or l (shiftLeftBy 1 d)


{-|
Rotate bits.
[📘](https://github.com/elmw/extra-boolean/wiki/rotate)

    -- x: an Int
    -- n: rotate amount (+ve: left, -ve: right)
    rotate 0x11112222 4  == 286401057 (0x11122221)
    rotate 0x11112222 -4 == 554766882 (0x21111222)
-}
rotate : Int -> Int -> Int
rotate x n =
  let neg = or (shiftLeftBy (32+n) x) (shiftRightZfBy (-n) x)
      pos = or (shiftLeftBy n x) (shiftRightZfBy (32-n) x) in
  if n<0 then neg else pos


{-|
Reverse all bits.
[📘](https://github.com/elmw/extra-boolean/wiki/reverse)

    -- x: an Int
    reverse 0xFFFF0000 == 65535     (0x0000FFFF)
    reverse 0x00AABBCC == 870143232 (0x33DD5500)
    reverse 0x1234     == 742916096 (0x2C480000)
-}
reverse : Int -> Int
reverse x =
  let a = or (and (shiftRightZfBy 1 x) 0x55555555) (shiftLeftBy 1 (and x 0x55555555))
      b = or (and (shiftRightZfBy 2 a) 0x33333333) (shiftLeftBy 2 (and a 0x33333333))
      c = or (and (shiftRightZfBy 4 b) 0x0F0F0F0F) (shiftLeftBy 4 (and b 0x0F0F0F0F))
      d = or (and (shiftRightZfBy 8 c) 0x00FF00FF) (shiftLeftBy 8 (and c 0x00FF00FF)) in
  or (shiftRightZfBy 16 d) (shiftLeftBy 16 d)


{-|
Sign extend variable bit-width integer.
[📘](https://github.com/elmw/extra-boolean/wiki/signExtend)

    -- x: variable bit-width Int
    -- w: bit width (32)
    signExtend 15 4 == -1 (1111 => -1)
    signExtend 3 3  == 3  (011  => 3)
    signExtend 4 3  == -4 (100  => -4)
-}
signExtend : Int -> Int -> Int
signExtend x w =
  let msb = and x (shiftLeftBy (w-1) 1) in
  if msb==0 then x else or (complement (and -1 ((shiftLeftBy w 1) - 1))) x
