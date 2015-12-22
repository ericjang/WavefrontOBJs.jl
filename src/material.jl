function loadMTL(io::IOStream)
  # loads material definitions from a .mtl file
  # returns: vector of materials
  # and a Dict{ASCIIString,Int32} mapping from obj name to
  # material index

  # initialize empty material
  m=Material()
  m_map=Dict{ASCIIString,Material}()

  for ln in eachline(io)
    # strip newline chars
    ln=replace(ln,"\n","")
    ln=replace(ln,"\r","")

    # split ln into tokens
    tokens=split(ln)

    # skip empty line
    if isempty(tokens)
      continue
    end

    # skip leading space
    if isempty(tokens[1])
      tokens=tokens[2:end]
    end

    x=tokens[1]
    if x=="#" # skip comment lines
      continue
    elseif x=="newmtl" # new material
      # flush previous material
      if !isempty(m.name)
        m_map[m.name]=deepcopy(m)
        m=Material()
      end
      m.name=tokens[2]
    elseif x=="Ka" # ambient
      m.ambient=parseVec3(tokens[2:4])
    elseif x=="Kd" # diffuse
      m.diffuse=parseVec3(tokens[2:4])
    elseif x=="Ks" # specular
      m.specular=parseVec3(tokens[2:4])
    elseif x=="Kt" || x=="Tf" # transmittance
      m.transmittance=parseVec3(tokens[2:4])
    elseif x=="Ni" # ior
      m.ior=parseFloat(tokens[2])
    elseif x=="Ke" # emission
      m.emission=parseVec3(tokens[2])
    elseif x=="Ns" # shininess
      m.shininess=parseFloat(tokens[2])
    elseif x=="illum" # illumination model
      m.illum=parseInt(tokens[2])
    elseif x=="d" # dissolve
      m.dissolve=parseFloat(tokens[2])
    elseif x=="Tr" # dissolve = 1-Tr (transmittance)
      m.dissolve=1-parseFloat(tokens[2])
    elseif x=="map_Ka" # ambient texture
      m.ambient_texname=tokens[2]
    elseif x=="map_Kd" # diffuse texture
      m.diffuse_texname=tokens[2]
    elseif x=="map_Ks" # specular texture
      m.specular_texname=tokens[2]
    elseif x=="map_Ns" # specular highlight texture
      m.specular_highlight_texname=tokens[2]
    elseif x=="map_bump" # bump texture
      m.bump_texname=tokens[2]
    elseif x=="bump" # bump texture
      m.bump_texname=tokens[2]
    elseif x=="disp" # displacement texture
      m.displacement_texname=tokens[2]
    elseif x=="map_d" # alpha texture
      m.alpha_texname=tokens[2]
    else # unknown parameter - insert it
      println("unknown parameter $ln")
      material.unknown_parameter[tokens[1]]=tokens[2]
    end
  end

  # flush the current material
  m_map[m.name]=m
  m_map
end

function loadMTL(fname::ASCIIString)
  m_map =()
  open(fname) do f
    m_map = loadMTL(f)
  end
  m_map
end
