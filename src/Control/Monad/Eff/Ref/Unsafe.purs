module Control.Monad.Eff.Ref.Unsafe where

import Control.Monad.Eff
import Control.Monad.Eff.Ref

foreign import unsafeRunRef 
  "function unsafeRunRef(f) {\
  \  return f;\
  \}" :: forall eff a. Eff (ref :: Ref | eff) a -> Eff eff a
