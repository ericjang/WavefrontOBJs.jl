module WavefrontOBJs

export loadOBJ, loadMTL, load_obj_mtl, numVertices, numFaces

include("geotypes.jl")
include("types.jl")
include("utils.jl")
include("obj.jl")
include("material.jl")

# convenience for loading OBJ and MTL simultaneously
function load_obj_mtl(fpath::ASCIIString)
  objpath=string(fpath,".obj")
  mtlpath=string(fpath,".mtl")
  if !isfile(objpath)
    error("OBJ file $objpath not found")
  end
  if !isfile(mtlpath)
    error("MTL file $mtlpath not found")
  end
  loadOBJ(objpath), loadMTL(mtlpath)
end


end # module
