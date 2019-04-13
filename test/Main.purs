module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import Test.Assert (assertEqual)

main :: Effect Unit
main = do
  -- initialize a new Ref with the value 0
  ref <- Ref.new 0

  -- read from it and check it
  curr1 <- Ref.read ref
  assertEqual { actual: curr1, expected: 0 }

  -- write over the ref with 1
  curr2 <- Ref.write 1 ref
  assertEqual { actual: curr2, expected: 1 }

  -- now it is 1 when we read out the value
  curr3 <- Ref.read ref
  assertEqual { actual: curr3, expected: 1 }

  -- modify it by adding 1 to the current state
  Ref.modify_ (\s -> s + 1) ref

  -- now it is 2 when we read out the value
  curr4 <- Ref.read ref
  assertEqual { actual: curr4, expected: 2 }
