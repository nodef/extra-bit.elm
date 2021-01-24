module Example exposing (..)

import Expect exposing (Expectation, equal)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Bit exposing (..)




-- GET*, SET*, TOGGLE*, SWAP
getTests : Test
getTests =
  describe "get x i" [
    test "0" <|
      \_ -> get 6 0 |> equal 0,
    test "1" <|
      \_ -> get 6 1 |> equal 1,
    test "2" <|
      \_ -> get 6 2 |> equal 1
  ]


getAsTests : Test
getAsTests =
  describe "getAs x m" [
    test "110,100 ⇒ 100" <|
      \_ -> getAs 6 4 |> equal 4,
    test "110,111 ⇒ 110" <|
      \_ -> getAs 6 7 |> equal 6,
    test "110,101 ⇒ 100" <|
      \_ -> getAs 6 5 |> equal 4
  ]


setTests : Test
setTests =
  describe "set x i f" [
    test "110,0,1 ⇒ 111" <|
      \_ -> set 6 0 1 |> equal 7,
    test "110,2,1 ⇒ 110" <|
      \_ -> set 6 2 1 |> equal 6,
    test "110,2,0 ⇒ 010" <|
      \_ -> set 6 2 0 |> equal 2
  ]


setAsTests : Test
setAsTests =
  describe "setAs x m f" [
    test "0x8 set 0x2 ⇒ 0xA" <|
      \_ -> setAs 8 2 1 |> equal 10,
    test "0xF clear 0x3 ⇒ 0xC" <|
      \_ -> setAs 15 3 0 |> equal 12,
    test "0x1234 set 0x430 ⇒ 0x1634" <|
      \_ -> setAs 0x1234 0x430 1 |> equal 5684
  ]


toggleTests : Test
toggleTests =
  describe "toggle x i" [
    test "110,0 ⇒ 111" <|
      \_ -> toggle 6 0 |> equal 7,
    test "110,1 ⇒ 100" <|
      \_ -> toggle 6 1 |> equal 4,
    test "110,2 ⇒ 010" <|
      \_ -> toggle 6 2 |> equal 2
  ]


toggleAsTests : Test
toggleAsTests =
  describe "toggleAs x m" [
    test "110,000 ⇒ 111" <|
      \_ -> toggleAs 6 1 |> equal 7,
    test "110,111 ⇒ 001" <|
      \_ -> toggleAs 6 7 |> equal 1,
    test "110,011 ⇒ 101" <|
      \_ -> toggleAs 6 3 |> equal 5
  ]


swapTests : Test
swapTests =
  describe "swap x i j n" [
    test "110 ⇒ 101" <|
      \_ -> swap 6 1 0 1 |> equal 5,
    test "0x1234 ⇒ 0x1324" <|
      \_ -> swap 0x1234 8 4 4 |> equal 0x1324,
    test "0x4AAB ⇒ 0xAB4A" <|
      \_ -> swap 0x4AAB 8 0 8 |> equal 0xAB4A
  ]




-- COUNT, PARITY, SCAN*
countTests : Test
countTests =
  describe "count x" [
    test "111 ⇒ 3" <|
      \_ -> count 7 |> equal 3,
    test "1100 ⇒ 2" <|
      \_ -> count 12 |> equal 2,
    test "111111 ⇒ 6" <|
      \_ -> count 63 |> equal 6
  ]


parityTests : Test
parityTests =
  describe "parity x n" [
    test "1,1,1 ⇒ 1" <|
      \_ -> parity 7 1 |> equal 1,
    test "1,0,1 ⇒ 0" <|
      \_ -> parity 5 1 |> equal 0,
    test "10,00 ⇒ 10" <|
      \_ -> parity 8 2 |> equal 2,
    test "11,1111 ⇒ 1100" <|
      \_ -> parity 63 4 |> equal 12
  ]


scanTests : Test
scanTests =
  describe "scan x" [
    test "111 ⇒ 0" <|
      \_ -> scan 7 |> equal 0,
    test "1100 ⇒ 2" <|
      \_ -> scan 12 |> equal 2,
    test "1000000 ⇒ 6" <|
      \_ -> scan 64 |> equal 6
  ]


scanReverseTests : Test
scanReverseTests =
  describe "scanReverse x" [
    test "1101 ⇒ 3" <|
      \_ -> scanReverse 13 |> equal 3,
    test "101 ⇒ 2" <|
      \_ -> scanReverse 5 |> equal 2,
    test "1 ⇒ 0" <|
      \_ -> scanReverse 1 |> equal 0
  ]




-- MERGE, INTERLEAVE, ROTATE, REVERSE, SIGNEXTEND
mergeTests : Test
mergeTests =
  describe "merge x y m" [
    test "0x14" <|
      \_ -> merge 0x12 0x24 0x0F |> equal 0x14,
    test "0x1B3D" <|
      \_ -> merge 0x1234 0xABCD 0x0F0F |> equal 0x1B3D,
    test "0xBBBB" <|
      \_ -> merge 0xAAAA 0xBBBB 0x3333 |> equal 0xBBBB
  ]


interleaveTests : Test
interleaveTests =
  describe "interleave x y" [
    test "0x55555555" <|
      \_ -> interleave 0x0000 0xFFFF |> equal 0x55555555,
    test "0x030C0F30" <|
      \_ -> interleave 0x1234 0x1234 |> equal 0x030C0F30,
    test "0x120D0E21" <|
      \_ -> interleave 0x1234 0x4321 |> equal 0x120D0E21
  ]


rotateTests : Test
rotateTests =
  describe "rotate x n" [
    test "0x11122221" <|
      \_ -> rotate 0x11112222 4 |> equal 0x11122221,
    test "0x21111222" <|
      \_ -> rotate 0x11112222 -4 |> equal 0x21111222
  ]


reverseTests : Test
reverseTests =
  describe "reverse x" [
    test "0x0000FFFF" <|
      \_ -> reverse 0xFFFF0000 |> equal 0x0000FFFF,
    test "0x33DD5500" <|
      \_ -> reverse 0x00AABBCC |> equal 0x33DD5500,
    test "0x2C480000" <|
      \_ -> reverse 0x1234 |> equal 0x2C480000
  ]


signExtendTests : Test
signExtendTests =
  describe "signExtend x w" [
    test "1111 ⇒ -1" <|
      \_ -> signExtend 15 4 |> equal -1,
    test "011 ⇒ 3" <|
      \_ -> signExtend 3 3 |> equal 3,
    test "100 ⇒ -4" <|
      \_ -> signExtend 4 3 |> equal -4
  ]
