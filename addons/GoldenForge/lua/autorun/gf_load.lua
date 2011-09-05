GF = {}

if (SERVER) then
	include("gf_server.lua")
else
	include("gf_client.lua")
end