-- | This module defines actions for working with mutable value references.
-- |
-- | _Note_: `Control.Monad.ST` provides a _safe_ alternative to `Ref` when
-- | mutation is restricted to a local scope.
module Effect.Ref
  ( Ref
  , new
  , read
  , modify'
  , modify
  , modify_
  , write
  ) where

import Prelude

import Effect (Effect)

-- | A value of type `Ref a` represents a mutable reference
-- | which holds a value of type `a`.
foreign import data Ref :: Type -> Type

-- | Create a new mutable reference containing the specified value.
foreign import new :: forall s. s -> Effect (Ref s)

-- | Read the current value of a mutable reference
foreign import read :: forall s. Ref s -> Effect s

-- | Update the value of a mutable reference by applying a function
-- | to the current value.
modify' :: forall s b. (s -> { state :: s, value :: b }) -> Ref s -> Effect b
modify' = modifyImpl

foreign import modifyImpl :: forall s b. (s -> { state :: s, value :: b }) -> Ref s -> Effect b

-- | Update the value of a mutable reference by applying a function
-- | to the current value. The updated value is returned.
modify :: forall s. (s -> s) -> Ref s -> Effect s
modify f = modify' \s -> let s' = f s in { state: s', value: s' }

modify_ :: forall s. (s -> s) -> Ref s -> Effect Unit
modify_ f s = void $ modify f s

-- | Update the value of a mutable reference to the specified value.
foreign import write :: forall s. s -> Ref s -> Effect Unit
