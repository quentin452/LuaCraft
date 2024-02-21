-- Définition de la taille d'un chunk
local size = 16
-- Chargement de la bibliothèque FFI (Foreign Function Interface)
local ffi = require "ffi"

-- Définition de la classe Chunk, étendant la classe Object
Chunk = Object:extend()
-- Définition de la taille du chunk
Chunk.size = size

-- Constructeur de la classe Chunk
function Chunk:new(x, y, z)
    -- Initialisation des données du chunk
    self.data = {}
    -- Coordonnées du chunk
    self.cx = x
    self.cy = y
    self.cz = z
    -- Position absolue du chunk dans le monde
    self.x = x * size
    self.y = y * size
    self.z = z * size
    -- Calcul du hash unique pour le chunk basé sur ses coordonnées
    self.hash = ("%d/%d/%d"):format(x, y, z)
    -- Initialisation d'autres variables de contrôle
    self.frames = 0
    self.inRemeshQueue = false

    -- Création et initialisation des données du chunk à l'aide de bruit de Perlin
    local data = love.data.newByteData(size * size * size * ffi.sizeof("uint8_t"))
    local datapointer = ffi.cast("uint8_t *", data:getFFIPointer())
    local f = 0.125
    for i = 0, size * size * size - 1 do
        local x, y, z = i % size + self.x, math.floor(i / size) % size + self.y, math.floor(i / (size * size)) + self.z
        -- Remplissage des données du chunk avec des valeurs basées sur le bruit de Perlin
        datapointer[i] = love.math.noise(x * f, y * f, z * f) > (z + 32) / 64 and 1 or 0
    end
    -- Attribution des données du chunk et de son pointeur à l'objet
    self.data = data
    self.datapointer = datapointer
end

-- Fonction pour obtenir le bloc à une position donnée dans le chunk
function Chunk:getBlock(x, y, z)
    -- Si le chunk est détruit, retourner -1
    if self.dead then return -1 end

    -- Si les coordonnées sont à l'intérieur des limites du chunk, retourner la valeur du bloc
    if x >= 0 and y >= 0 and z >= 0 and x < size and y < size and z < size then
        local i = x + size * y + size * size * z
        return self.datapointer[i]
    end

    -- Si les coordonnées sortent du chunk, obtenir le bloc du chunk voisin s'il existe
    local chunk = scene():getChunkFromWorld(self.x + x, self.y + y, self.z + z)
    if chunk then return chunk:getBlock(x % size, y % size, z % size) end
    return -1
end

-- Fonction pour définir la valeur d'un bloc à une position donnée dans le chunk
function Chunk:setBlock(x, y, z, value)
    -- Si le chunk est détruit, retourner -1
    if self.dead then return -1 end

    -- Si les coordonnées sont à l'intérieur des limites du chunk, définir la valeur du bloc
    if x >= 0 and y >= 0 and z >= 0 and x < size and y < size and z < size then
        local i = x + size * y + size * size * z
        self.datapointer[i] = value
        return
    end

    -- Si les coordonnées sortent du chunk, définir la valeur du bloc dans le chunk voisin s'il existe
    local chunk = scene():getChunkFromWorld(self.x + x, self.y + y, self.z + z)
    if chunk then return chunk:setBlock(x % size, y % size, z % size, value) end
end

-- Fonction pour dessiner le chunk
function Chunk:draw()
    -- Si le modèle du chunk existe et que le chunk n'est pas détruit, dessiner le modèle
    if self.model and not self.dead then
        self.model:draw()
    end
end

-- Fonction pour détruire le chunk
function Chunk:destroy()
    -- Libérer les ressources du modèle si elles existent
    if self.model then self.model.mesh:release() end
    -- Marquer le chunk comme détruit et libérer ses données
    self.dead = true
    self.data:release()
    -- Supprimer le chunk de la carte des chunks de la scène
    scene().chunkMap[self.hash] = nil
end
