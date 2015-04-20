# Module Documentation

## Module Control.Monad.Eff.Ref


This module defines an effect and actions for working with
global mutable variables.

_Note_: The `Control.Monad.ST` provides a _safe_ alternative
to global mutable variables when mutation is restricted to a
local scope.

#### `REF`

``` purescript
data REF :: !
```

The effect associated with the use of global mutable variables.

#### `Ref`

``` purescript
data Ref :: * -> *
```

A value of type `Ref a` represents a mutable reference
which holds a value of type `a`.

#### `newRef`

``` purescript
newRef :: forall s r. s -> Eff (ref :: REF | r) (Ref s)
```

Create a new mutable reference containing the specified value.

#### `readRef`

``` purescript
readRef :: forall s r. Ref s -> Eff (ref :: REF | r) s
```

Read the current value of a mutable reference

#### `modifyRef'`

``` purescript
modifyRef' :: forall s b r. Ref s -> (s -> { value :: b, state :: s }) -> Eff (ref :: REF | r) b
```

Update the value of a mutable reference by applying a function
to the current value.

#### `modifyRef`

``` purescript
modifyRef :: forall s r. Ref s -> (s -> s) -> Eff (ref :: REF | r) Unit
```

Update the value of a mutable reference by applying a function
to the current value.

#### `writeRef`

``` purescript
writeRef :: forall s r. Ref s -> s -> Eff (ref :: REF | r) Unit
```

Update the value of a mutable reference to the specified value.


## Module Control.Monad.Eff.Ref.Unsafe


Unsafe functions for working with mutable references.

#### `unsafeRunRef`

``` purescript
unsafeRunRef :: forall eff a. Eff (ref :: REF | eff) a -> Eff eff a
```

This handler function unsafely removes the `Ref` effect from an
effectful action.

This function might be used when it is impossible to prove to the
typechecker that a particular mutable reference does not escape
its scope.