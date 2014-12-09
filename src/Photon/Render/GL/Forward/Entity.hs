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

module Photon.Render.OpenGL.Forward.Entity (
    -- *
    entityTransform
  , cameraTransform
  ) where

import Control.Lens
import Linear
import Photon.Core.Entity

-- TODO: support scale matrix
entityTransform :: Entity a -> M44 Float
entityTransform e = mkTransformation o p
  where
    p = e^.entityPosition
    o = e^.entityOrientation

cameraTransform :: Entity a -> M44 Float
cameraTransform e = quaternionMatrix o !*! translationMatrix p
  where
    p = e^.entityPosition
    o = e^.entityOrientation

translationMatrix :: (Num a) => V3 a -> M44 a
translationMatrix (V3 x y z) =
    V4
      (V4 1 0 0 x)
      (V4 0 1 0 y)
      (V4 0 0 1 z)
      (V4 0 0 0 1)

quaternionMatrix :: (Num a) => Quaternion a -> M44 a
quaternionMatrix q =
    V4
      (fix4 rx)
      (fix4 ry)
      (fix4 rz)
      (V4 0 0 0 1)
  where
    V3 rx ry rz = fromQuaternion q
    fix4 (V3 x y z) = V4 x y z 0