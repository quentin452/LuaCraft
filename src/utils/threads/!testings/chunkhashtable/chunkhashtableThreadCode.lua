ChunkHashTableChannel,ChunkHashTableTesting = ...

while true do
	local message = ChunkHashTableChannel:demand()
	if message then
		-- Récupération de la clé et de la valeur du message
		local key, value = unpack(message)
		-- Mise à jour de la table dans le thread séparé
		ChunkHashTableTesting[key] = value
		print("Table mise à jour dans le thread séparé:", key, value)
	end
end
