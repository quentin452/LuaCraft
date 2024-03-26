cmake_minimum_required(VERSION 3.28)
project(cpp_rewrite)

# Définir le répertoire SFML
set(SFML_DIR "${CMAKE_SOURCE_DIR}/libs/SFML-2.6.1/lib/cmake/SFML")

# Trouver et inclure SFML
find_package(SFML 2.6 COMPONENTS graphics window system REQUIRED)

# Définir les sources de l'exécutable
set(SOURCES 
    "src/main.cpp"
    "src/VulkanRenderer.cpp"
    "src/VulkanRenderer.h"
    "src/gamestatehandling/core/GameState.h"
    "src/gamestatehandling/core/GameStateManager.h"
    "src/gamestatehandling/states/MainMenuState.h"
    "src/gamestatehandling/states/MainMenuState.cpp"
    "src/gamestatehandling/states/SettingsState.cpp"
    "src/gamestatehandling/states/SettingsState.h"
    "src/gamestatehandling/states/VulkanGameState.cpp"
    "src/gamestatehandling/states/VulkanGameState.h"
    "src/gamescene/3DGameScene.cpp"
    "src/gamescene/3DGameScene.h"
)

# Créer l'exécutable
add_executable(${PROJECT_NAME} ${SOURCES})
target_include_directories(${PROJECT_NAME} PUBLIC "${SFML_INCLUDE_DIRS}")

set(OPENGL32_LIBRARY "${CMAKE_SOURCE_DIR}/libs/opengl/OpenGL32.lib")

# Spécifier le chemin d'accès aux en-têtes de FreeType
set(FREETYPE_INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/libs/freetype-2.8.1/include")

# Inclure les en-têtes de FreeType dans la cible exécutable
include_directories(${FREETYPE_INCLUDE_DIRS})

# Spécifier le chemin d'accès à la bibliothèque FreeType
set(FREETYPE_LIBRARY "${CMAKE_SOURCE_DIR}/libs/freetype-2.8.1/freetypelib/freetype.lib")

# Lier la bibliothèque FreeType à la cible exécutable
target_link_libraries(${PROJECT_NAME} ${FREETYPE_LIBRARY})

# Spécifier le chemin d'accès aux fichiers d'en-tête GLFW
set(GLFW_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/libs/glfw-3.4/include")

# Inclure les fichiers d'en-tête GLFW dans la cible exécutable
target_include_directories(${PROJECT_NAME} PUBLIC ${GLFW_INCLUDE_DIR})

# Spécifier le chemin d'accès aux bibliothèques GLFW
# set(GLFW_LIBRARY_DIR "${CMAKE_SOURCE_DIR}/libs/glfw-3.4.bin.WIN64/lib-vc2022")


# Spécifier le chemin d'accès aux bibliothèques GLFW
set(GLFW_LIBRARY "${CMAKE_SOURCE_DIR}/libs/glfw-3.4.bin.WIN64/lib-vc2022/glfw3.lib")

# Lier les bibliothèques GLFW à la cible exécutable
target_link_libraries(${PROJECT_NAME} ${GLFW_LIBRARY})

set(glfw3_DIR "${CMAKE_SOURCE_DIR}/libs/glfw-3.4/CMake")

# Lier les bibliothèques GLFW à la cible exécutable
# target_link_libraries(${PROJECT_NAME} ${GLFW_LIBRARY_DIR})

# Lier les bibliothèques GLFW à la cible exécutable
target_link_libraries(${PROJECT_NAME} ${OPENGL32_LIBRARY}) 
target_link_libraries(${PROJECT_NAME} sfml-graphics sfml-window sfml-system)

# Copier les fichiers DLL de SFML dans le répertoire de sortie de l'exécutable
set(SFML_DLL_DIR "${CMAKE_SOURCE_DIR}/libs/SFML-2.6.1/bin")
file(GLOB SFML_DLLS "${SFML_DLL_DIR}/*.dll")
foreach(DLL ${SFML_DLLS})
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${DLL}"
        $<TARGET_FILE_DIR:${PROJECT_NAME}>)
endforeach()

# Chemin d'accès au fichier Arial.ttf
set(ARIAL_FONT_PATH "${CMAKE_SOURCE_DIR}/Arial.ttf")

# Copier Arial.ttf dans le répertoire de sortie de l'exécutable
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${ARIAL_FONT_PATH}"
    $<TARGET_FILE_DIR:${PROJECT_NAME}>)