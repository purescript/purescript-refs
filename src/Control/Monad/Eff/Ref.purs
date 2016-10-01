-- | This module defines an effect and actions for working with
-- | global mutable variables.
-- |
-- | _Note_: The `Control.Monad.ST` provides a _safe_ alternative
-- | to global mutable variables when mutation is restricted to a
-- | local scope.
module Control.Monad.Eff.Ref where

import Prelude (Unit, unit)
import Control.Monad.Eff (Eff)

-- | The effect associated with the use of global mutable variables.
foreign import data REF :: !

-- | A value of type `Ref a` represents a mutable reference
-- | which holds a value of type `a`.
foreign import data Ref :: * -> *

-- | Create a new mutable reference containing the specified value.
foreign import newRef :: forall s r. s -> Eff (ref :: REF | r) (Ref s)

-- | Read the current value of a mutable reference
foreign import readRef :: forall s r. Ref s -> Eff (ref :: REF | r) s

-- | Update the value of a mutable reference by applying a function
-- | to the current value.
foreign import modifyRef' :: forall s b r. Ref s -> (s -> { state :: s, value :: b }) -> Eff (ref :: REF | r) b

-- | Update the value of a mutable reference by applying a function
-- | to the current value.
modifyRef :: forall s r. Ref s -> (s -> s) -> Eff (ref :: REF | r) Unit
modifyRef ref f = modifyRef' ref (\s -> { state: f s, value: unit })

-- | Update the value of a mutable reference to the specified value.
foreign import writeRef :: forall s r. Ref s -> s -> Eff (ref :: REF | r) Unit
