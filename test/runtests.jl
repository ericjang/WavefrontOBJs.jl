using WavefrontOBJs
using Base.Test

#
# OBJ TESTING
#

# TOOD - usemtl should flush stuff as well?
# tallbox didn't get anything

shapes = loadOBJ("CornellBox/CornellBox-Original.obj")

# for s in shapes
#   println("-------------")
#   println("group: $(s.group)")
#   println("vertices: $(numVertices(s))")
#   println("faces: $(numFaces(s))")
# end

@test length(shapes)==8

D=Dict([s.group=>s for s in shapes])

for name in ["floor","ceiling","backWall","rightWall","leftWall"]
  s=D[name]
  @test numVertices(s)==4
  @test numFaces(s)==2
  @test s.material==name
end

for name in ["shortBox","tallBox"]
  s=D[name]
  @test numVertices(s)==20
  @test numFaces(s)==12
  @test s.material==name
end

#
# Blender OBJ testing
#
shapes = loadOBJ("blender.obj")
D=Dict([s.name=>s for s in shapes])

#s1=D["Icosphere"]

s2=D["Cube"]
@test numFaces(s2)==12
@test numVertices(s2)==8
@test length(s2.vn)==6
@test length(s2.fv)==length(s2.fn)

# print positions of cube vertices
# for f=s2.fv
#   v1=s2.v[f[1]]
#   v2=s2.v[f[2]]
#   v3=s2.v[f[3]]
#   println("$v1 \t $v2 \t $v3")
# end


#
# MATERIAL TESTING
#
materials = loadMTL("CornellBox/CornellBox-Original.mtl")

# left wall
@test length(materials)==8
m=materials["leftWall"]
@test m.name=="leftWall"
@test m.ambient==vec3(0.63,0.065,0.05)
@test m.diffuse==vec3(0.63,0.065,0.05)
@test m.transmittance==vec3(0)
@test m.emission==vec3(0)
@test m.shininess==10.0
@test m.ior==1.5
@test m.dissolve==1
@test m.illum==2
@test m.ambient_texname==""
@test m.diffuse_texname==""
@test m.specular_texname==""
@test m.specular_highlight_texname==""
@test m.bump_texname==""
@test m.displacement_texname==""
@test m.alpha_texname==""
@test isempty(m.unknown_parameter)

materials = loadMTL("CornellBox/CornellBox-Sphere.mtl")

m=materials["light"]
@test m.name=="light"
@test m.ambient==vec3(0.78,0.78,0.78)
@test m.diffuse==vec3(0.78,0.78,0.78)
@test m.transmittance==vec3(1.0)
@test m.emission==vec3(10)
@test m.shininess==10.0
@test m.ior==1.5
@test m.dissolve==1
@test m.illum==2
@test m.ambient_texname==""
@test m.diffuse_texname==""
@test m.specular_texname==""
@test m.specular_highlight_texname==""
@test m.bump_texname==""
@test m.displacement_texname==""
@test m.alpha_texname==""
@test isempty(m.unknown_parameter)

# make sure that all faces are converted into triangles.

#
# SIMULTANEOUS OBJ/MTL loading
#
meshes,materials=load_obj_mtl("CornellBox/CornellBox-Original")
