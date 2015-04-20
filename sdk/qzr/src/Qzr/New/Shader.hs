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

module Qzr.New.Shader (
    -- * Create new shader Haskell modules
    newShader
  ) where

import Quaazar.Render.GLSL
import System.FilePath ( (<.>) )

newShader :: String -> IO ()
newShader name = writeFile (name <.> "hs") (shaderTemplate name)

shaderTemplate :: String -> String
shaderTemplate name = unlines
  [
    replicate 79 '-'
  , "-- generated by: qzr new shader"
  , replicate 79 '-'
  , "module " ++ name ++ " where"
  , ""
  , "shaderStage :: String"
  , "shaderStage = unlines"
  , "  ["
  , "    -- Available vertex shader inputs:"
  , "    --   * [vec3]             coInput             : vertex's coordinates"
  , "    --   * [vec3]             noInput             : vertex's normal"
  , "    --   * [vec2]             uvInput             : vertex's UV coordinates"
  , "    --"
  , "    -- Available uniform semantics:"
  , "    --   * [mat4]             camProjViewSem      : camera projection matrix"
  , "    --   * [vec3]             eyeSem              : camera position"
  , "    --   * [mat4]             modelSem            : model matrix"
  , "    --   * [vec3]             ligAmbColSem        : ambient light color"
  , "    --   * [float]            ligAmbPowSem        : ambient light power"
  , "    --   * [uint]             ligOmniNbSem        : number of omnidirectional lights"
  , "    --   * [mat4]             ligProjViewsSem     : omnidirectional view matrix array"
  , "    --   *                      0 : +X"
  , "    --   *                      1 : -X"
  , "    --   *                      2 : +Y"
  , "    --   *                      4 : -Y"
  , "    --   *                      4 : +Z"
  , "    --   *                      5 : -Z"
  , "    --   * [samplerCubeArray] lowShadowmapsSem : low shadow cubemap array"
  , "    --   * [samplerCubeArray] mediumShadowmapsSem : medium shadow cubemap array"
  , "    --   * [samplerCubeArray] highShadowmapsSem   : high shadow cubemap array"
  , "    --"
  , "    -- Available uniform block binding points:"
  , "    --   * [OmniBuffer]       ligOmniSSBOBP       : buffer of omnidirectional lights"
  , "    --"
  , "    -- Built-in structures:"
  , "    \"struct Omni {\""
  , "  , \"  vec3 pos;\""
  , "  , \"  vec3 col;\""
  , "  , \"  float pow;\""
  , "  , \"  float rad;\""
  , "  , \"  uint shadowLOD;\""
  , "  , \"  uint shadowmapIndex;\""
  , "  , \" };\""
  , "  ]"
  ]
