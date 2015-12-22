# WavefrontOBJs

[![Build Status](https://travis-ci.org/ericjang/WavefrontOBJs.jl.svg?branch=master)](https://travis-ci.org/ericjang/WavefrontOBJs.jl)

WavefrontOBJs is a Julia package for loading Wavefront OBJ geometry and Wavefront MTL materials.

The implementation is based on [tinyobjloader](https://github.com/syoyo/tinyobjloader).

Implements subsets of the [.obj](http://www.martinreddy.net/gfx/3d/OBJ.spec) and [.mtl](http://paulbourke.net/dataformats/mtl/) specifications. This should be suitable for most things.

## Usage:

```julia
using WavefrontOBJs
meshes = loadOBJ("CornellBox/CornellBox-Original.obj")
materials = loadMTL("CornellBox/CornellBox-Original.mtl")
# Alternatively, you can load both OBJs and MTLs simultaneously via:
meshes, materials = load_obj_mtl("CornellBox/CornellBox-Original")
```
