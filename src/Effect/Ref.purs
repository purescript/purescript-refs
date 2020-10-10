-- | This module defines actions for working with mutable value references.
-- |
-- | _Note_: `Control.Monad.ST` provides a _safe_ alternative to `Ref` when
-- | mutation is restricted to a local scope.
-- |
-- | You'll notice that all of the functions that operate on a `Ref`
-- | (e.g. `new`, `modify`, `modify_`, `read`) return an `Effect (Ref s)`
-- | and not a `Ref s`. Here's what would happe if the `Ref s` was not
-- | wrapped in an `Effect`:
-- | 1. In some situations, one could violate referential transparency.
-- | 2. One can violate the type system by giving a `Ref` a polymorphic type
-- |    and then specializing it after the fact.
-- |
-- | In regards to the first, consider the below example:
-- | ```
-- | let
-- |   x = Ref.new “hi”
-- |   first = Tuple x x
-- |   second = Tuple (Ref.new "hi") (Ref.new "hi")
-- | ```
-- | In the above code, `first` would be the same as `second` if it upheld
-- | referential transparency. However, `first` holds the same reference twice
-- | whereas `second` holds two different references. Thus, it invalidates
-- | referential transparency. By making `Ref.new` return an `Effect`, a
-- | new separate reference is created each time.
-- |
-- | In regards to the second, consider the below example:
-- | ```
-- | let
-- |   ref :: forall a. Ref (Maybe a)
-- |   ref = Ref.new Nothing
-- | in
-- |   Tuple (ref :: Ref (Maybe Int)) (ref :: Ref (Maybe String))
-- | ```
-- | The Tuple stores the same reference twice, but its type is `Maybe Int` in
-- | one situation and `Maybe String` in another.
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
