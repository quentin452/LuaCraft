cmake_minimum_required(VERSION 3.0)
project(cpp_rewrite)

# Définir le répertoire SFML
set(SFML_DIR "${CMAKE_SOURCE_DIR}/libs/SFML-2.6.1/lib/cmake/SFML")

# Trouver et inclure SFML
find_package(SFML 2.6 COMPONENTS graphics window system REQUIRED)
message(SFML INCLUDE DIR ${SFML_INCLUDE_DIRS})

# Définir les sources de l'exécutable
set(SOURCES 
main.cpp
"gamestatehandling/GameState.h"
"gamestatehandling/GameStateManager.h"
"gamestatehandling/MainMenuState.h"
"gamestatehandling/MainMenuState.cpp"
"gamestatehandling/SettingsState.cpp"
"gamestatehandling/SettingsState.h"
)

# Créer l'exécutable
add_executable(${PROJECT_NAME} ${SOURCES})

# Inclure les répertoires d'en-têtes de SFML dans la cible exécutable
target_include_directories(${PROJECT_NAME} PUBLIC "${SFML_INCLUDE_DIRS}")

# Liens avec les bibliothèques SFML
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
set(ARIAL_FONT_PATH "${CMAKE_SOURCE_DIR}/arial.ttf")

# Copier Arial.ttf dans le répertoire de sortie de l'exécutable
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${ARIAL_FONT_PATH}"
    $<TARGET_FILE_DIR:${PROJECT_NAME}>)
