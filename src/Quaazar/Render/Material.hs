-----------------------------------------------------------------------------
-- |
-- Copyright   : (C) 2014 Dimitri Sabadie
-- License     : BSD3
--
-- Maintainer  : Dimitri Sabadie <dimitri.sabadie@gmail.com>
-- Stability   : experimental
-- Portability : portable
--
----------------------------------------------------------------------------

module Quaazar.Render.Material (
    -- * GPU-side material
    GPUMaterial(..)
  , gpuMaterial
  ) where

import Quaazar.Core.Material ( Albedo, Material(..), MaterialLayer(..) )
import Quaazar.Render.GL.Shader ( Uniform, (@=) )
import Quaazar.Render.GPU

newtype GPUMaterial = GPUMaterial {
    runMaterial :: Uniform Albedo -- ^ diffuse albedo
                -> Uniform Albedo -- ^ specular albedo
                -> Uniform Float -- ^ shininess
                -> IO ()
  }

instance GPU Material GPUMaterial where
  gpu = gpuMaterial

-- TODO: implement multilayered material
gpuMaterial :: (Monad m) => Material -> m GPUMaterial
gpuMaterial (Material []) = return . GPUMaterial $ \_ _ _ -> return ()
gpuMaterial (Material (MaterialLayer dalb salb shn:_)) =
  return . GPUMaterial $ \diffu specu shnu -> do
    diffu @= dalb
    specu @= salb
    shnu @= shn