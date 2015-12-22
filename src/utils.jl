parseVec3= (tokens)->vec3(float(tokens)...)
parseiVec3= (tokens)->ivec3([parse(Int32,s) for s = tokens]...)
parseFloat= (s)->parse(Float32,s)
parseInt= (s)->parse(Int32,s)
