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

module BoundingVolume (
    -- *
  ) where

import Data.List ( maximumBy )
import Data.Ord ( comparing )
import Photon.Core.Vertex ( Vertices(..) )

data BoundingVolume
  = BSphere Float          -- ^ radius
  | AABB Float Float Float -- ^ width, height and depth
    deriving (Eq,Show)

-- |Construct a bounding sphere from vertices.
bsphere :: Vertices -> BoundingVolume
bsphere verts = BSphere $ case verts of
    Interleaved vs       -> maximumBy (comparing . norm $ view vertexPosition) vs
    Deinterleaved ps _ _ -> maximum $ map norm ps

minmax :: (Ord a) => [a] -> (a,a)
minmax []     = error "empty list: minmax"
minmax (x:xs) = foldl (\(mn,mx) a -> (min mn a,max mx a)) (x,x) xs
