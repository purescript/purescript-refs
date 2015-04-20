-- | This module defines an effect and actions for working with
-- | global mutable variables.
-- |
-- | _Note_: The `Control.Monad.ST` provides a _safe_ alternative
-- | to global mutable variables when mutation is restricted to a
-- | local scope.

module Control.Monad.Eff.Ref where

import Control.Monad.Eff (Eff())

-- | The effect associated with the use of global mutable variables.
foreign import data REF :: !

-- | A value of type `Ref a` represents a mutable reference
-- | which holds a value of type `a`.
foreign import data Ref :: * -> *

-- | Create a new mutable reference containing the specified value.
foreign import newRef
  """
  function newRef(val) {
    return function () {
      return { value: val };
    };
  }
  """ :: forall s r. s -> Eff (ref :: REF | r) (Ref s)

-- | Read the current value of a mutable reference
foreign import readRef
  """
  function readRef(ref) {
    return function() {
      return ref.value;
    };
  }
  """ :: forall s r. Ref s -> Eff (ref :: REF | r) s

-- | Update the value of a mutable reference by applying a function
-- | to the current value.
foreign import modifyRef'
  """
  function modifyRef$prime(ref) {
    return function(f) {
      return function() {
        var t = f(ref.value);
        ref.value = t.state;
        return t.value;
      };
    };
  }
  """ :: forall s b r. Ref s -> (s -> { state :: s, value :: b }) -> Eff (ref :: REF | r) b

-- | Update the value of a mutable reference by applying a function
-- | to the current value.
modifyRef :: forall s r. Ref s -> (s -> s) -> Eff (ref :: REF | r) Unit
modifyRef ref f = modifyRef' ref (\s -> { state: f s, value: unit })

-- | Update the value of a mutable reference to the specified value.
foreign import writeRef
  """
  function writeRef(ref) {
    return function(val) {
      return function() {
        ref.value = val;
        return {};
      };
    };
  }
  """ :: forall s r. Ref s -> s -> Eff (ref :: REF | r) Unit
