type Material
  name::ASCIIString
  ambient::vec3 # Ka
  diffuse::vec3 # Kd
  specular::vec3 # Ks
  transmittance::vec3 # Tf 0 1 0 allows all green light to pass through
  emission::vec3 #
  shininess::Float32
  ior::Float32
  dissolve::Float32 # 1 = opaque, 0=transparent
  illum::Int32
  ambient_texname::ASCIIString # map_Ka
  diffuse_texname::ASCIIString # map_Kd
  specular_texname::ASCIIString # map_Ks
  specular_highlight_texname::ASCIIString # map_Ns
  bump_texname::ASCIIString # map_bump, bump
  displacement_texname::ASCIIString # disp
  alpha_texname::ASCIIString # map_d
  unknown_parameter::Dict{ASCIIString, ASCIIString}
end

# constructor
Material()=Material(
  "", # name
  vec3(0),vec3(0),vec3(0),vec3(0),vec3(0), # ambient-emission
  0,0,1,0, #shininess-illum
  "","","","","","","", #texnames
  Dict{ASCIIString,ASCIIString}()
)

type Shape
  name::ASCIIString
  group::ASCIIString
  material::ASCIIString # material name
  v::Vector{vec3} # vertex locations
  vn::Vector{vec3} # vertex normals
  vt::Vector{vec2} # texture coordinates
  fv::Vector{ivec3} # face indices
  fn::Vector{ivec3} # vertex normals of face
  ft::Vector{ivec3} # texture coordinates of face
end

# constructor
Shape()=Shape(
  "","","",
  Vector{vec3}(),
  Vector{vec3}(),
  Vector{vec2}(),
  Vector{ivec3}(),
  Vector{ivec3}(),
  Vector{ivec3}()
)
