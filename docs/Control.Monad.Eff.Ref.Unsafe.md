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


