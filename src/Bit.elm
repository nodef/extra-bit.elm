module Bit exposing (..)
import Basics exposing (remainderBy)
import Array exposing (Array, fromList)
import Bitwise exposing (and, or, complement, shiftLeftBy, shiftRightZfBy)
import Bitwise exposing (shiftRightBy)



-- Global data
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


-- Helper functions
bxor : Int -> Int -> Int
bxor = Bitwise.xor

arrayGet : d -> Int -> Array d -> d
arrayGet d i x =
  Maybe.withDefault d (Array.get i x)




count : Int -> Int
count x =
  let a = x - (and (shiftRightZfBy 1 x) 0x55555555)
      b = (and a 0x33333333) + (and (shiftRightZfBy 2 a) 0x33333333) in
  shiftRightZfBy 24 ((and (b + (shiftRightZfBy 4 b)) 0x0F0F0F0F) * 0x01010101)


get : Int -> Int -> Int
get x i =
  and (shiftRightZfBy i x) 1


getAs : Int -> Int -> Int
getAs x m =
  and x m


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


merge : Int -> Int -> Int -> Int
merge x y m =
  bxor x (and (bxor x y) m)




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



reverse : Int -> Int
reverse x =
  let a = or (and (shiftRightZfBy 1 x) 0x55555555) (shiftLeftBy 1 (and x 0x55555555))
      b = or (and (shiftRightZfBy 2 a) 0x33333333) (shiftLeftBy 2 (and a 0x33333333))
      c = or (and (shiftRightZfBy 4 b) 0x0F0F0F0F) (shiftLeftBy 4 (and b 0x0F0F0F0F))
      d = or (and (shiftRightZfBy 8 c) 0x00FF00FF) (shiftLeftBy 8 (and c 0x00FF00FF)) in
  or (shiftRightZfBy 16 d) (shiftLeftBy 16 d)



rotate : Int -> Int -> Int
rotate x n =
  let neg = or (shiftLeftBy (32+n) x) (shiftRightZfBy (-n) x)
      pos = or (shiftLeftBy n x) (shiftRightZfBy (32-n) x) in
  if n<0 then neg else pos



scan : Int -> Int
scan x =
  arrayGet 0 (remainderBy 37 (and (-x) x)) mod37Pos32


scanReverse : Int -> Int
scanReverse x =
  let a = or x (shiftRightZfBy 1 x)
      b = or a (shiftRightZfBy 2 a)
      c = or b (shiftRightZfBy 4 b)
      d = or c (shiftRightZfBy 8 c)
      e = or d (shiftRightZfBy 16 d) in
  arrayGet 0 (shiftRightZfBy 27 (e*0x07C4ACDD)) debruijnPos32


set : Int -> Int -> Int -> Int
set x i f =
  or (and x (complement (shiftLeftBy i 1))) (shiftLeftBy i f)


setAs : Int -> Int -> Int -> Int
setAs x m f =
  or (and x (complement m)) (and (-f) m)


signExtend : Int -> Int -> Int
signExtend x w =
  let u = 32-w in
  shiftRightBy w (shiftLeftBy w x)


swap : Int -> Int -> Int -> Int -> Int
swap x i j n =
  let t = and (bxor (shiftRightZfBy i x) (shiftRightZfBy j x)) ((shiftLeftBy n 1) - 1) in
  bxor x (or (shiftLeftBy i t) (shiftLeftBy j t))


toggle : Int -> Int -> Int
toggle x i =
  bxor x (shiftLeftBy i 1)


toggleAs : Int -> Int -> Int
toggleAs x m =
  bxor x m
