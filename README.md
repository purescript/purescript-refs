# Module Documentation

## Module Control.Monad.Eff.Ref

### Types

    data Ref :: !

    data RefVal :: * -> *


### Values

    modifyRef :: forall s r. RefVal s -> (s -> s) -> Eff (ref :: Ref | r) Unit

    modifyRef' :: forall s b r. RefVal s -> (s -> { retVal :: b, newState :: s }) -> Eff (ref :: Ref | r) b

    newRef :: forall s r. s -> Eff (ref :: Ref | r) (RefVal s)

    readRef :: forall s r. RefVal s -> Eff (ref :: Ref | r) s

    writeRef :: forall s r. RefVal s -> s -> Eff (ref :: Ref | r) Unit


## Module Control.Monad.Eff.Ref.Unsafe

### Values

    unsafeRunRef :: forall eff a. Eff (ref :: Ref | eff) a -> Eff eff a