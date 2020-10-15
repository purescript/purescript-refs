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
  Ref.write 1 ref

  -- now it is 1 when we read out the value
  curr2 <- Ref.read ref
  assertEqual { actual: curr2, expected: 1 }

  -- modify it by adding 1 to the current state
  Ref.modify_ (\s -> s + 1) ref

  -- now it is 2 when we read out the value
  curr3 <- Ref.read ref
  assertEqual { actual: curr3, expected: 2 }

  selfRef

newtype RefBox = RefBox { ref :: Ref.Ref RefBox, value :: Int }

selfRef :: Effect Unit
selfRef = do
  -- Create a self-referential `Ref`
  ref <- Ref.newWithSelf \ref -> RefBox { ref, value: 0 }

  -- Grab the `Ref` from within the `Ref`
  ref' <- Ref.read ref <#> \(RefBox r) -> r.ref

  -- Modify the `ref` and check that value in `ref'` changes
  Ref.modify_ (\(RefBox r) -> RefBox (r { value = 1 })) ref
  assertEqual
    <<< { expected: 1, actual: _ }
    =<< (Ref.read ref' <#> \(RefBox { value }) -> value)

  -- Modify the `ref'` and check that value in `ref` changes
  Ref.modify_ (\(RefBox r) -> RefBox (r { value = 2 })) ref'
  assertEqual
    <<< { expected: 2, actual: _ }
    =<< (Ref.read ref <#> \(RefBox { value }) -> value)
