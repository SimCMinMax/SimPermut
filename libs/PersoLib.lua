local MAJOR, MINOR = "PersoLib", 1
local PersoLib = LibStub:NewLibrary(MAJOR, MINOR)

if not PersoLib then return end

function PersoLib:slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end

function PersoLib:firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function PersoLib:doCartesianALACON(tableToPermut)
	local i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14
	local tableReturn={}
	
	--print("permut :")
	for i1=1,#tableToPermut[1] do
		for i2=1,#tableToPermut[2] do
			for i3=1,#tableToPermut[3] do
				for i4=1,#tableToPermut[4] do
					for i5=1,#tableToPermut[5] do
						for i6=1,#tableToPermut[6] do
							for i7=1,#tableToPermut[7] do
								for i8=1,#tableToPermut[8] do
									for i9=1,#tableToPermut[9] do
										for i10=1,#tableToPermut[10] do
											for i11=1,#tableToPermut[11] do
												for i12=1,#tableToPermut[12] do
													for i13=1,#tableToPermut[13] do
														for i14=1,#tableToPermut[14] do
															tableReturn[#tableReturn+1]={}
															tableReturn[#tableReturn][1]=tableToPermut[1][i1]
															tableReturn[#tableReturn][2]=tableToPermut[2][i2]
															tableReturn[#tableReturn][3]=tableToPermut[3][i3]
															tableReturn[#tableReturn][4]=tableToPermut[4][i4]
															tableReturn[#tableReturn][5]=tableToPermut[5][i5]
															tableReturn[#tableReturn][6]=tableToPermut[6][i6]
															tableReturn[#tableReturn][7]=tableToPermut[7][i7]
															tableReturn[#tableReturn][8]=tableToPermut[8][i8]
															tableReturn[#tableReturn][9]=tableToPermut[9][i9]
															tableReturn[#tableReturn][10]=tableToPermut[10][i10]
															tableReturn[#tableReturn][11]=tableToPermut[11][i11]
															tableReturn[#tableReturn][12]=tableToPermut[12][i12]
															tableReturn[#tableReturn][13]=tableToPermut[13][i13]
															tableReturn[#tableReturn][14]=tableToPermut[14][i14]
															--print(tableToPermut[1][i1].." "..tableToPermut[2][i2].." "..tableToPermut[3][i3].." "..tableToPermut[4][i4].." "..tableToPermut[5][i5].." "..tableToPermut[6][i6].." "..tableToPermut[7][i7].." "..tableToPermut[8][i8].." "..tableToPermut[9][i9].." "..tableToPermut[10][i10].." "..tableToPermut[11][i11].." "..tableToPermut[12][i12])
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	
	
	return tableReturn
end

function PersoLib:tokenize(str)
  str = str or ""
  -- convert to lowercase and remove spaces
  str = string.lower(str)
  str = string.gsub(str, ' ', '_')

  -- keep stuff we want, dumpster everything else
  local s = ""
  for i=1,str:len() do
    -- keep digits 0-9
    if str:byte(i) >= 48 and str:byte(i) <= 57 then
      s = s .. str:sub(i,i)
      -- keep lowercase letters
    elseif str:byte(i) >= 97 and str:byte(i) <= 122 then
      s = s .. str:sub(i,i)
      -- keep %, +, ., _
    elseif str:byte(i)==37 or str:byte(i)==43 or str:byte(i)==46 or str:byte(i)==95 then
      s = s .. str:sub(i,i)
    end
  end
  -- strip trailing spaces
  if string.sub(s, s:len())=='_' then
    s = string.sub(s, 0, s:len()-1)
  end
  return s
end
