-- | Unsafe functions for working with mutable references.

module Control.Monad.Eff.Ref.Unsafe where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Ref (REF)
import Control.Monad.Eff.Unsafe (unsafeCoerceEff)

-- | This handler function unsafely removes the `Ref` effect from an
-- | effectful action.
-- |
-- | This function might be used when it is impossible to prove to the
-- | typechecker that a particular mutable reference does not escape
-- | its scope.
unsafeRunRef :: forall eff a. Eff (ref :: REF | eff) a -> Eff eff a
unsafeRunRef = unsafeCoerceEff
