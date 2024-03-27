cmake_minimum_required(VERSION 3.28)
project(cpp_rewrite)

# Définir le répertoire source
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")

# Trouver tous les fichiers source dans le répertoire source
file(GLOB_RECURSE SOURCES "${SRC_DIR}/*.cpp" "${SRC_DIR}/*.h")

# Créer l'exécutable
add_executable(${PROJECT_NAME} ${SOURCES})

# Spécifier le chemin d'accès aux en-têtes de FreeType
set(FREETYPE_INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/libs/freetype-2.8.1/include")

# Inclure les en-têtes de FreeType dans la cible exécutable
include_directories(${FREETYPE_INCLUDE_DIRS})

set(OPENGL32_LIBRARY "${CMAKE_SOURCE_DIR}/libs/opengl/OpenGL32.lib")

# Spécifier le chemin d'accès à la bibliothèque FreeType
set(FREETYPE_LIBRARY "${CMAKE_SOURCE_DIR}/libs/freetype-2.8.1/freetypelib/freetype.lib")

# Lier la bibliothèque FreeType à la cible exécutable
target_link_libraries(${PROJECT_NAME} ${FREETYPE_LIBRARY})

# Spécifier le chemin d'accès aux fichiers d'en-tête GLFW
set(GLFW_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/libs/glfw-3.4/include")

# Inclure les fichiers d'en-tête GLFW dans la cible exécutable
target_include_directories(${PROJECT_NAME} PUBLIC ${GLFW_INCLUDE_DIR})

# Spécifier le chemin d'accès aux bibliothèques GLFW
set(GLFW_LIBRARY "${CMAKE_SOURCE_DIR}/libs/glfw-3.4.bin.WIN64/lib-vc2022/glfw3.lib")

# Lier les bibliothèques GLFW à la cible exécutable
target_link_libraries(${PROJECT_NAME} ${GLFW_LIBRARY})

# Spécifier le chemin d'accès aux en-têtes Vulkan
set(VULKAN_INCLUDE_DIR 
   "${CMAKE_SOURCE_DIR}/libs/Vulkan-Headers-main/include/vulkan"
   "${CMAKE_SOURCE_DIR}/libs/Vulkan-Headers-main/include/vk_video"
)

# Inclure les fichiers d'en-tête Vulkan dans la cible exécutable
include_directories(${VULKAN_INCLUDE_DIR})

target_link_libraries(${PROJECT_NAME} ${OPENGL32_LIBRARY}) 
# Spécifier le chemin d'accès à la bibliothèque Vulkan
set(VULKAN_LIBRARY "${CMAKE_SOURCE_DIR}/libs/vulkanlib/vulkan-1.lib")

# Lier la bibliothèque Vulkan à la cible exécutable
target_link_libraries(${PROJECT_NAME} ${VULKAN_LIBRARY})

# Spécifier le chemin d'accès aux en-têtes Glad
set(GLAD_INCLUDE_DIR 
   "${CMAKE_SOURCE_DIR}/libs/glad/include/glad"
)

# Inclure les fichiers d'en-tête Glad dans la cible exécutable
include_directories(${GLAD_INCLUDE_DIR})

# Spécifier le chemin d'accès aux en-têtes Noise
set(NOISE_INCLUDE_DIR 
   "${CMAKE_SOURCE_DIR}/libs/noise"
)

# Inclure les fichiers d'en-tête Noise dans la cible exécutable
include_directories(${NOISE_INCLUDE_DIR})

# Spécifier le chemin d'accès aux en-têtes STB
set(STB_INCLUDE_DIR 
   "${CMAKE_SOURCE_DIR}/libs/stb"
)

# Inclure les fichiers d'en-tête STB dans la cible exécutable
include_directories(${STB_INCLUDE_DIR})

# Spécifier le chemin d'accès aux fichiers d'en-tête GLEW
set(GLEW_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/libs/glew-2.1.0/include/GL")

# Inclure les fichiers d'en-tête GLEW dans la cible exécutable
include_directories(${GLEW_INCLUDE_DIR})

# Spécifier le chemin d'accès à la bibliothèque GLEW
set(GLEW_LIBRARY "${CMAKE_SOURCE_DIR}/libs/glew-2.1.0/lib/Release/x64/glew32.lib")

# Lier la bibliothèque GLEW à la cible exécutable
target_link_libraries(${PROJECT_NAME} ${GLEW_LIBRARY})

# Spécifier le chemin d'accès aux fichiers d'en-tête GLEW
set(GLTEXT_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/libs/gltext")

# Inclure les fichiers d'en-tête GLEW dans la cible exécutable
include_directories(${GLTEXT_INCLUDE_DIR})

# Chemin d'accès au fichier Arial.ttf
set(ARIAL_FONT_PATH "${CMAKE_SOURCE_DIR}/Arial.ttf")

# Copier Arial.ttf dans le répertoire de sortie de l'exécutable
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${ARIAL_FONT_PATH}"
    $<TARGET_FILE_DIR:${PROJECT_NAME}>
)
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_SOURCE_DIR}/libs/glew-2.1.0/lib/Release/x64/glew32.dll"
    $<TARGET_FILE_DIR:${PROJECT_NAME}>
)
