-- | This module defines an effect and actions for working with
-- | global mutable variables.
-- |
-- | _Note_: The `Control.Monad.ST` provides a _safe_ alternative
-- | to global mutable variables when mutation is restricted to a
-- | local scope.
module Control.Monad.Effect.Ref where

import Control.Monad.Effect (Effect)
import Prelude (Unit, unit)

-- | A value of type `Ref a` represents a mutable reference
-- | which holds a value of type `a`.
foreign import data Ref :: Type -> Type

-- | Create a new mutable reference containing the specified value.
foreign import newRef :: forall s. s -> Effect (Ref s)

-- | Read the current value of a mutable reference
foreign import readRef :: forall s. Ref s -> Effect s

-- | Update the value of a mutable reference by applying a function
-- | to the current value.
foreign import modifyRef' :: forall s b. Ref s -> (s -> { state :: s, value :: b }) -> Effect b

-- | Update the value of a mutable reference by applying a function
-- | to the current value.
modifyRef :: forall s. Ref s -> (s -> s) -> Effect Unit
modifyRef ref f = modifyRef' ref (\s -> { state: f s, value: unit })

-- | Update the value of a mutable reference to the specified value.
foreign import writeRef :: forall s. Ref s -> s -> Effect Unit
