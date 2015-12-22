using ImmutableArrays

export vec2,vec3,vec4
export ivec2,ivec3,ivec4
export mat2,mat3,mat4

typealias vec2 Vector2{Float32}
typealias vec3 Vector3{Float32}
typealias vec4 Vector4{Float32}

typealias ivec2 Vector2{Int32}
typealias ivec3 Vector3{Int32}
typealias ivec4 Vector4{Int32}

vec2(x)=vec2(x,x)
vec3(x)=vec3(x,x,x)
vec4(x)=vec4(x,x,x,x)
ivec2(x)=ivec2(x,x)
ivec3(x)=ivec3(x,x,x)
ivec4(x)=ivec4(x,x,x,x)

typealias mat2 Matrix2x2{Float32}
typealias mat3 Matrix3x3{Float32}
typealias mat4 Matrix4x4{Float32}
