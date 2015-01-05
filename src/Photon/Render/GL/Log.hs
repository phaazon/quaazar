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

module Photon.Render.GL.Log (
  -- * OpenGL logs
  gllog
  ) where

import Photon.Utils.Log ( LogCommitter(BackendLog) )

gllog :: LogCommitter
gllog = BackendLog "gl"