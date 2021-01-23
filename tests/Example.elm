module Example exposing (..)

import Expect exposing (Expectation, equal)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Bit exposing (..)




-- GET*, SET*, TOGGLE*, SWAP
getTests : Test
getTests =
  describe "get x i" [
    test "get 6 0 == 0 (110,0 => 0)" <|
      \_ -> get 6 0 |> equal 0,
    test "get 6 1 == 1 (110,1 => 1)" <|
      \_ -> get 6 1 |> equal 1,
    test "get 6 2 == 1 (110,2 => 1)" <|
      \_ -> get 6 2 |> equal 1
  ]


getAsTests : Test
getAsTests =
  describe "getAs x m" [
    test "getAs 6 4 == 4 (110,100 => 100)" <|
      \_ -> getAs 6 4 |> equal 4,
    test "getAs 6 7 == 6 (110,111 => 110)" <|
      \_ -> getAs 6 7 |> equal 6,
    test "getAs 6 5 == 4 (110,101 => 100)" <|
      \_ -> getAs 6 5 |> equal 4
  ]


setTests : Test
setTests =
  describe "set x i f" [
    test "set 6 0 1 == 7 (110,0,1 => 111)" <|
      \_ -> set 6 0 1 |> equal 7,
    test "set 6 2 1 == 6 (110,2,1 => 110)" <|
      \_ -> set 6 2 1 |> equal 6,
    test "set 6 2 0 == 2 (110,2,0 => 010)" <|
      \_ -> set 6 2 0 |> equal 2
  ]


setAsTests : Test
setAsTests =
  describe "setAs x m f" [
    test "setAs 8 2 1          == 10   (0x8 set 0x2      => 0xA)" <|
      \_ -> setAs 8 2 1 |> equal 10,
    test "setAs 15 3 0         == 12   (0xF clear 0x3    => 0xC)" <|
      \_ -> setAs 15 3 0 |> equal 12,
    test "setAs 0x1234 0x430 1 == 5684 (0x1234 set 0x430 => 0x1634)" <|
      \_ -> setAs 0x1234 0x430 1 |> equal 5684
  ]


toggleTests : Test
toggleTests =
  describe "toggle x i" [
    test "toggle 6 0 == 7 (110,0 => 111)" <|
      \_ -> toggle 6 0 |> equal 7,
    test "toggle 6 1 == 4 (110,1 => 100)" <|
      \_ -> toggle 6 1 |> equal 4,
    test "toggle 6 2 == 2 (110,2 => 010)" <|
      \_ -> toggle 6 2 |> equal 2
  ]


toggleAsTests : Test
toggleAsTests =
  describe "toggleAs x m" [
    test "toggleAs 6 1 == 7 (110,000 => 111)" <|
      \_ -> toggleAs 6 1 |> equal 7,
    test "toggleAs 6 7 == 1 (110,111 => 001)" <|
      \_ -> toggleAs 6 7 |> equal 1,
    test "toggleAs 6 3 == 5 (110,011 => 101)" <|
      \_ -> toggleAs 6 3 |> equal 5
  ]


swapTests : Test
swapTests =
  describe "swap x i j n" [
    test "swap 6 1 0 1      == 5     (110    => 101)" <|
      \_ -> swap 6 1 0 1 |> equal 5,
    test "swap 0x1234 8 4 4 == 4900  (0x1234 => 0x1324)" <|
      \_ -> swap 0x1234 8 4 4 |> equal 0x1324,
    test "swap 0x4AAB 8 0 8 == 43850 (0x4AAB => 0xAB4A)" <|
      \_ -> swap 0x4AAB 8 0 8 |> equal 0xAB4A
  ]




-- COUNT, PARITY, SCAN*
countTests : Test
countTests =
  describe "count x" [
    test "count 7  == 3 (111    => 3)" <|
      \_ -> count 7 |> equal 3,
    test "count 12 == 2 (1100   => 2)" <|
      \_ -> count 12 |> equal 2,
    test "count 63 == 6 (111111 => 6)" <|
      \_ -> count 63 |> equal 6
  ]


parityTests : Test
parityTests =
  describe "parity x n" [
    test "parity 7 1  == 1  (1,1,1   => 1)" <|
      \_ -> parity 7 1 |> equal 1,
    test "parity 5 1  == 0  (1,0,1   => 0)" <|
      \_ -> parity 5 1 |> equal 0,
    test "parity 8 2  == 2  (10,00   => 10)" <|
      \_ -> parity 8 2 |> equal 2,
    test "parity 63 4 == 12 (11,1111 => 1100)" <|
      \_ -> parity 63 4 |> equal 12
  ]


scanTests : Test
scanTests =
  describe "scan x" [
    test "scan 7  == 0 (111     => 0)" <|
      \_ -> scan 7 |> equal 0,
    test "scan 12 == 2 (1100    => 2)" <|
      \_ -> scan 12 |> equal 2,
    test "scan 64 == 6 (1000000 => 6)" <|
      \_ -> scan 64 |> equal 6
  ]


scanReverseTests : Test
scanReverseTests =
  describe "scanReverse x" [
    test "scanReverse 13 == 3 (1101 => 3)" <|
      \_ -> scanReverse 13 |> equal 3,
    test "scanReverse 5  == 2 (101  => 2)" <|
      \_ -> scanReverse 5 |> equal 2,
    test "scanReverse 1  == 0 (1    => 0)" <|
      \_ -> scanReverse 1 |> equal 0
  ]




-- MERGE, INTERLEAVE, ROTATE, REVERSE, SIGNEXTEND
mergeTests : Test
mergeTests =
  describe "merge x y m" [
    test "merge 0x12 0x24 0x0F       == 20    (0x14)" <|
      \_ -> merge 0x12 0x24 0x0F |> equal 0x14,
    test "merge 0x1234 0xABCD 0x0F0F == 6973  (0x1B3D)" <|
      \_ -> merge 0x1234 0xABCD 0x0F0F |> equal 0x1B3D,
    test "merge 0xAAAA 0xBBBB 0x3333 == 48059 (0xBBBB)" <|
      \_ -> merge 0xAAAA 0xBBBB 0x3333 |> equal 0xBBBB
  ]


interleaveTests : Test
interleaveTests =
  describe "interleave x y" [
    test "interleave 0x0000 0xFFFF == 1431655765 (0x55555555)" <|
      \_ -> interleave 0x0000 0xFFFF |> equal 0x55555555,
    test "interleave 0x1234 0x1234 == 51121968   (0x030C0F30)" <|
      \_ -> interleave 0x1234 0x1234 |> equal 0x030C0F30,
    test "interleave 0x1234 0x4321 == 302845473  (0x120D0E21)" <|
      \_ -> interleave 0x1234 0x4321 |> equal 0x120D0E21
  ]


rotateTests : Test
rotateTests =
  describe "rotate x n" [
    test "rotate 0x11112222 4  == 286401057 (0x11122221)" <|
      \_ -> rotate 0x11112222 4 |> equal 0x11122221,
    test "rotate 0x11112222 -4 == 554766882 (0x21111222)" <|
      \_ -> rotate 0x11112222 -4 |> equal 0x21111222
  ]


reverseTests : Test
reverseTests =
  describe "reverse x" [
    test "reverse 0xFFFF0000 == 65535     (0x0000FFFF)" <|
      \_ -> reverse 0xFFFF0000 |> equal 0x0000FFFF,
    test "reverse 0x00AABBCC == 870143232 (0x33DD5500)" <|
      \_ -> reverse 0x00AABBCC |> equal 0x33DD5500,
    test "reverse 0x1234     == 742916096 (0x2C480000)" <|
      \_ -> reverse 0x1234 |> equal 0x2C480000
  ]


signExtendTests : Test
signExtendTests =
  describe "signExtend x w" [
    test "signExtend 15 4 == -1 (1111 => -1)" <|
      \_ -> signExtend 15 4 |> equal -1,
    test "signExtend 3 3  == 3  (011  => 3)" <|
      \_ -> signExtend 3 3 |> equal 3,
    test "signExtend 4 3  == -4 (100  => -4)" <|
      \_ -> signExtend 4 3 |> equal -4
  ]
