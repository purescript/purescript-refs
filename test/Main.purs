module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Ref.Unsafe (unsafeRunRef)

import Test.Assert (ASSERT)
import Test.Control.Monad.Eff.Ref (testRef)

main :: Eff (console :: CONSOLE, assert :: ASSERT) Unit
main = unsafeRunRef do
  log "unsafeRunRef"
  testRef
