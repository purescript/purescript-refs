module Test.Control.Monad.Eff.Ref (testRef) where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Ref (REF, Ref, newRef, readRef, (%%=), (%=), (.=))

import Test.Assert (ASSERT, assert)

type EffTestRef = Eff (console :: CONSOLE, assert :: ASSERT, ref :: REF) Unit

testRef :: EffTestRef
testRef = do
  ref <- newRef true
  testReadRef ref true
  testWriteRef
  testModifyRef
  testModifyRef'

testReadRef :: forall a. Eq a => Ref a -> a -> EffTestRef
testReadRef ref expected = do
  log "readRef"
  actual <- readRef ref
  assert $ actual == expected

testWriteRef :: EffTestRef
testWriteRef = do
  log "writeRef"
  ref <- newRef true
  ref .= false
  testReadRef ref false

testModifyRef :: EffTestRef
testModifyRef = do
  log "modifyRef"
  ref <- newRef true
  val <- ref %= not
  assert $ val == false
  testReadRef ref false

testModifyRef' :: EffTestRef
testModifyRef' = do
  log "modifyRef'"
  ref <- newRef true
  val <- ref %%= \old -> { newValue: old, returnValue: not old}
  assert $ val == false
  testReadRef ref true
