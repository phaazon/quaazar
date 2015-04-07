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

module Quaazar.Render.Camera where

import Control.Lens
import Data.Maybe ( fromJust )
import Linear ( M44, V3, (!*!), inv44 )
import Quaazar.Core.Transform ( Transform, transformPosition )
import Quaazar.Core.Projection ( Projection, projectionMatrix )
import Quaazar.Render.Transform ( cameraMatrix )
import Quaazar.Render.GL.Shader ( Uniform, (@=) )

data GPUCamera = GPUCamera {
    runCamera :: Uniform (M44 Float) -- ^ projection * view
              -> Uniform (M44 Float) -- ^ (projection * view)-1
              -> Uniform (V3 Float) -- ^ eye
              -> IO ()
  , cameraProjection :: M44 Float
  }

gpuCamera :: Projection -> Transform -> GPUCamera
gpuCamera proj ent = GPUCamera sendCamera proj'
  where
    sendCamera projViewU iProjViewU eyeU = do
        projViewU @= projView
        iProjViewU @= fromJust (inv44 projView)
        eyeU @= ent^.transformPosition
    projView = proj' !*! cameraMatrix ent
    proj' = projectionMatrix proj
