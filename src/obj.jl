# TODO - need to come up with a better state transition diagram


function loadOBJ(io::IOStream)
  # loads OBJ mesh from file
  # all polygons converted into triangles
  # returns Vector{Shape}

  # list of shapes to return
  shapes=Vector{Shape}()

  # any of these vertices may be referenced at any time during parse
  v_all=Vector{vec3}()
  vn_all=Vector{vec3}()
  vt_all=Vector{vec2}()

  # anytime "o","g",or "usemtl" occurs, if we have stored geometry
  # we flush the previously stored (name,group,material) combo
  # in any case, change name, group, material accordingly
  name, group, material="","",""
  s=Shape() # store the current geom
  # OBJ format can contain relative indices so we need to
  # pack the indices right away
  cv,cn,ct=0,0,0
  vmap=Dict{Int32,Int32}()
  nmap=Dict{Int32,Int32}()
  tmap=Dict{Int32,Int32}()

  # flushes the previous facegroup
  function exportShape()
    # a new object is exported each time a material is declared
    if !isempty(s.v)
      s.name,s.group,s.material=name,group,material
      push!(shapes,deepcopy(s))
    end
    # reset stuff
    s=Shape()
    cv,cn,ct=0,0,0
    vmap=Dict{Int32,Int32}()
    nmap=Dict{Int32,Int32}()
    tmap=Dict{Int32,Int32}()
  end

  for ln in eachline(io)
    # strip newline chars
    ln=replace(ln,"\n","")
    ln=replace(ln,"\r","")

    # strip trailing comments on the line
    j=search(ln,'#')
    if (j!=0)
      ln=ln[1:j-1]
    end

    # split ln into tokens
    tokens=split(ln)
    # println(tokens)

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
    elseif x=="v"
      push!(v_all,parseVec3(tokens[2:4]))
    elseif x=="vn"
      push!(vn_all,parseVec3(tokens[2:4]))
    elseif x=="vt"
      t=parseVec3(tokens[2:4])
      push!(vt_all,vec2(t.x,t.y))
    elseif x=="f"
      # assumption: face expressed in one of the following 3 formats,
      # with 3 or more vertices. no mixing allowed!
      # case 1: f v v v
      # case 2: f v//vn v//vn v//vn
      # case 3: f v/vt/vn v/vt/vn v/vt/vn v/vt/vn
      tmp =[split(t,"/") for t in tokens[2:end]]
      ngon=length(tmp)
      # v
      vs=[parse(Int32,t[1]) for t in tmp]
      ns,ts=[],[]
      if length(tmp[1]) == 3
        if tmp[1][2]!="" # case 3
          ts=[parse(Int32,t[2]) for t in tmp]
        end
        ns=[parse(Int32,t[3]) for t in tmp]
      end

      # now we have original vertices parsed
      # remap indices

      # convert relative indices to absolute
      vs=[i<0 ? length(v_all)+i+1 : i for i in vs]
      ns=[i<0 ? length(vn_all)+i+1 : i for i in ns]
      ts=[i<0 ? length(vt_all)+i+1 : i for i in ts]

      # actual vertex data
      for v in vs
        if !haskey(vmap,v)
          vmap[v]=(cv+=1)
          push!(s.v,v_all[v])
        end
      end
      for n in ns
        if !haskey(nmap,n)
          nmap[n]=(cn+=1)
          push!(s.vn,vn_all[n])
        end
      end
      for t in ts
        if t<0
          t=length(vt_all)-t
        end
        if !haskey(tmap,t)
          tmap[t]=(ct+=1)
          push!(s.vt,vt_all[t])
        end
      end

      # convert n-gon into triangle fan
      # vertex indices
      i0,i1,i2=vs[1],0,vs[2]
      for k=3:ngon
        i1,i2=i2,vs[k]
        push!(s.fv,ivec3(vmap[i0],vmap[i1],vmap[i2]))
      end

      # normals triangulated in the same order
      if length(ns) >= 3
        i0,i1,i2=ns[1],0,ns[2]
        for k=3:ngon
          i1,i2=i2,ns[k]
          push!(s.fn,ivec3(nmap[i0],nmap[i1],nmap[i2]))
        end
      end

      if length(ts) >= 3
        i0,i1,i2=ts[1],0,ts[2]
        for k=3:ngon
          i1,i2=i2,ts[k]
          push!(s.ft,ivec3(tmap[i0],tmap[i1],tmap[i2]))
        end
      end
    elseif x=="o"
      exportShape()
      name=tokens[2]
    elseif x=="g" # for now, assume these do the same thing and flush
      exportShape()
      group=tokens[2]
    elseif x=="usemtl"
      exportShape()
      material=tokens[2]
    elseif x=="mtllib" # don't care - MTL is parsed independently
      continue
    elseif x=="s" # smoothing group - ignore for now
      continue
    else # unknown
      println("unknown $ln")
    end
  end
  # flush one more time
  exportShape()
  shapes
end

function loadOBJ(fname::ASCIIString)
  shapes =()
  open(fname) do f
    shapes = loadOBJ(f)
  end
  shapes
end

# helper methods
function numVertices(s::Shape)
  length(s.v)
end

function numFaces(s::Shape)
  # number of triangle faces
  length(s.fv)
end
