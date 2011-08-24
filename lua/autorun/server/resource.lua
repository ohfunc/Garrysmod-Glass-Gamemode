--What shit do users have to download when connecting?
resource.AddFile("particles/gl_powerup_particles.pcf")

function AddDir(dir) // recursively adds everything in a directory to be downloaded by client
	local list = file.FindDir("../"..dir.."/*")
	for _, fdir in pairs(list) do
		if fdir != ".svn" then // don't spam people with useless .svn folders
			AddDir(dir.."/"..fdir)
		end
	end
 
	for k,v in pairs(file.Find("../"..dir.."/*")) do
		resource.AddFile(dir.."/"..v)
	end
end
 
AddDir("materials/glass_textures")