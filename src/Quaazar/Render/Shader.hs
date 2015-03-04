{-# LANGUAGE RankNTypes #-}

-----------------------------------------------------------------------------
-- |
-- Copyright   : (C) 2015 Dimitri Sabadie
-- License     : BSD3
--
-- Maintainer  : Dimitri Sabadie <dimitri.sabadie@gmail.com>
-- Stability   : experimental
-- Portability : portable
--
----------------------------------------------------------------------------

module Quaazar.Render.Shader where

import Control.Monad.Error.Class ( MonadError )
import Control.Monad.Trans ( MonadIO(..) )
import Data.Foldable ( traverse_ )
import Quaazar.Render.GL.Shader ( Uniformable, (@=), buildProgram, getUniform )
import qualified Quaazar.Render.GL.Shader as GL ( useProgram )
import Quaazar.Utils.Log
import Quaazar.Utils.Scoped

newtype GPUProgram a = GPUProgram { useProgram :: a -> IO () }

gpuProgram :: (MonadScoped IO m,MonadIO m,MonadLogger m,MonadError Log m)
           => String
           -> Maybe String
           -> String
           -> ((forall u. (Uniformable u) => String -> IO (Maybe u -> IO ())) -> IO (a -> IO ()))
           -> m (GPUProgram a)
gpuProgram vs gs fs uniforms = do
    program <- buildProgram vs gs fs
    update <- liftBase $ uniforms (uniformize program)
    return . GPUProgram $ \a -> do
      GL.useProgram program
      update a
  where
    uniformize program name = do
      u <- getUniform program name
      return $ traverse_ (u @=)
