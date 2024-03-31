# TODO OPTIMIZE THIS CODE TO REDUCE REDUDANCY AND IMPROVE readability
cmake_minimum_required(VERSION 3.28)
project(LUACRAFT)

add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD")

# Enable LTO Optimizations(Link-Time Optimization) 
option(ENABLE_LTO "Enable Link-Time Optimization" ON)

if(ENABLE_LTO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result)
    if(result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)
    else()
        message(WARNING "IPO/LTO not supported: ${output}")
    endif()
endif()

# Set common directories
set(LIB_DIR "${CMAKE_SOURCE_DIR}/libs")
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")

# Find source files
file(GLOB_RECURSE SOURCES "${SRC_DIR}/*.cpp" "${SRC_DIR}/*.h" "${SRC_DIR}/*.hpp")

set(SOURCES_FILES ${SOURCES})

set(build_directory "${CMAKE_CURRENT_BINARY_DIR}/")

# External libraries
set(FREETYPE_INCLUDE_DIR "${LIB_DIR}/freetype-2.8.1/include")
set(GLFW_INCLUDE_DIR "${LIB_DIR}/glfw-3.4.bin.WIN64/include")
set(VULKAN_INCLUDE_DIRS "${LIB_DIR}/Vulkan-Headers-main/include/vulkan")
set(VULKAN_INCLUDE_DIRSVKVideo "${LIB_DIR}/Vulkan-Headers-main/include/vk_video")
set(GLAD_INCLUDE_DIR "${LIB_DIR}/glad/include/glad")
set(STB_INCLUDE_DIR "${LIB_DIR}/stb")
set(GLEW_INCLUDE_DIR "${LIB_DIR}/glew-2.1.0/include")
set(GLTEXT_INCLUDE_DIR "${LIB_DIR}/gltext")
set(SDL2_INCLUDE_DIR "${LIB_DIR}/SDL2-2.30.1/include")
set(SDL2_TTF_INCLUDE_DIR "${LIB_DIR}/SDL2_ttf-2.22.0")
set(SDL2_IMAGE_INCLUDE_DIR "${LIB_DIR}/SDL2_image-2.8.2/include")
set(SDL2_MIXER_INCLUDE_DIR "${LIB_DIR}/SDL2_mixer-2.8.0/include")
set(BOOST_INCLUDE_DIR "${LIB_DIR}/boost_1_85_0")
set(TINYENGINE_INCLUDE_DIR "${LIB_DIR}/TinyEngine-master")

set(GLM_INCLUDE_DIR "${LIB_DIR}/glm-1.0.1-light/glm")
set(EIGEN_INCLUDE_DIR "${LIB_DIR}/eigen-3.4.0")
set(IMGUI_INCLUDE_DIR "${LIB_DIR}/imgui-x")

set(OPENGL_LIBRARY "${LIB_DIR}/opengl/OpenGL32.lib")
set(GLFW_LIBRARY "${LIB_DIR}/glfw-3.4.bin.WIN64/lib-vc2022/glfw3.lib")
set(VULKAN_LIBRARY "${LIB_DIR}/vulkanlib/vulkan-1.lib")
set(GLEW_LIBRARY "${LIB_DIR}/glew-2.1.0/lib/Release/x64/glew32.lib")
set(SDL2_LIBRARY "${LIB_DIR}/SDL2-2.30.1-win32-x64/SDL2d.lib")
set(SDL2_TTF_LIBRARY "${LIB_DIR}/SDL2_image-2.8.2-win32-x64/SDL2_imaged.lib")
set(SDL2_IMAGE_LIBRARY "${LIB_DIR}/SDL2_ttf-2.22.0-win32-x64/SDL2_ttfd.lib")
set(SDL2_MIXER_LIBRARY "${LIB_DIR}/SDL2_mixer-2.8.0-win32-x64/SDL2_mixer.lib")
set(IMGUI_LIBRARY "${LIB_DIR}/ImGuiLib/ImGui.lib")
set(FREETYPE_LIBRARY "${LIB_DIR}/freetype-2.8.1/freetypelib/freetype.lib")
set(BOOST_LIBRARY_DIR "${LIB_DIR}/boost_1_85_0/stage/lib")
file(GLOB BOOST_LIBRARIES "${BOOST_LIBRARY_DIR}/*")

get_directory_property(VS_INCLUDE_DIRECTORIES INCLUDE_DIRECTORIES) 
get_directory_property(WIN_SDK_INCLUDE_DIRECTORIES INCLUDE_DIRECTORIES)
if(NOT DEFINED VS_INCLUDE_DIRECTORIES)
  get_directory_property(...)
endif()

if(NOT DEFINED WIN_SDK_INCLUDE_DIRECTORIES)
  get_directory_property(...)  
endif()

# Add executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Target include directories
target_include_directories(${PROJECT_NAME} PUBLIC  ${TINYENGINE_INCLUDE_DIR} ${GLFW_INCLUDE_DIR} ${EIGEN_INCLUDE_DIR} ${IMGUI_INCLUDE_DIR} ${VULKAN_INCLUDE_DIRS} ${FREETYPE_INCLUDE_DIR} ${VULKAN_INCLUDE_DIRSVKVideo} ${GLAD_INCLUDE_DIR} ${STB_INCLUDE_DIR} ${GLEW_INCLUDE_DIR} ${SDL2_INCLUDE_DIR} ${SDL2_TTF_INCLUDE_DIR} ${SDL2_IMAGE_INCLUDE_DIR} ${SDL2_MIXER_INCLUDE_DIR} ${BOOST_INCLUDE_DIR} ${GLM_INCLUDE_DIR} ${GLTEXT_INCLUDE_DIR} ${GLTEXT_INCLUDE_DIR})

# Create a list of DLLs to copy
set(DLL_LIST
    "${LIB_DIR}/glew-2.1.0/lib/Release/x64/glew32.dll"
    "${LIB_DIR}/SDL2-2.30.1-win32-x64/SDL2.dll"
    "${LIB_DIR}/SDL2-2.30.1-win32-x64/SDL2d.dll"
    "${LIB_DIR}/SDL2_image-2.8.2-win32-x64/SDL2_image.dll"
    "${LIB_DIR}/SDL2_image-2.8.2-win32-x64/SDL2_imaged.dll"
    "${LIB_DIR}/SDL2_mixer-2.8.0-win32-x64/SDL2_mixer.dll"
    "${LIB_DIR}/SDL2_ttf-2.22.0-win32-x64/SDL2_ttfd.dll"
    "${LIB_DIR}/SDL2_ttf-2.22.0-win32-x64/SDL2_ttf.dll"
)

# Copy DLLs after build if they don't exist already
foreach(DLL ${DLL_LIST})
    file(TO_NATIVE_PATH "${DLL}" NATIVE_DLL_PATH)
    get_filename_component(DLL_NAME "${DLL}" NAME)
    set(DESTINATION_PATH "$<TARGET_FILE_DIR:${PROJECT_NAME}>/${DLL_NAME}")
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${NATIVE_DLL_PATH}"
        "${DESTINATION_PATH}"
        COMMENT "Copying ${DLL_NAME} to output directory"
        VERBATIM
        )
endforeach()

# Link libraries
target_link_libraries(${PROJECT_NAME} PRIVATE ${GLFW_LIBRARY} ${OPENGL_LIBRARY} ${FREETYPE_LIBRARY} ${VULKAN_LIBRARY} ${GLEW_LIBRARY} ${BOOST_LIBRARIES} ${SDL2_LIBRARY} ${SDL2_IMAGE_LIBRARY} ${SDL2_TTF_LIBRARY} ${SDL2_MIXER_LIBRARY} ${IMGUI_LIBRARY} )

# Generate Compilations DataBase Section

# Common compilation options
# TODO MADE -std=c++14 etc... not hardcoded
set(common_compile_options
   -std=c++14 
   -Wall 
   -fms-compatibility-version=19.10 
   -Wmicrosoft 
   -Wno-invalid-token-paste 
   -Wno-unknown-pragmas 
   -Wno-unused-value 
   -fsyntax-only 
   "\\\"-D_MT\\\"" 
   "\\\"-D_DLL\\\"" 
   "\\\"-DWIN32\\\"" 
   "\\\"-D_WINDOWS\\\"" 
   "\\\"-DCMAKE_INTDIR=/\\\"Debug/\\\"\\\"" 
   "\\\"-D_DEBUG_FUNCTIONAL_MACHINERY\\\""   
   -isystem "\\\"${VS_INCLUDE_DIRECTORIES}/include\\\""
   -isystem "\\\"${VS_INCLUDE_DIRECTORIES}/atlmfc/include\\\""
   -isystem "\\\"${WIN_SDK_INCLUDE_DIRECTORIES}//ucrt\\\""
   -isystem "\\\"${WIN_SDK_INCLUDE_DIRECTORIES}//um\\\""
   -isystem "\\\"${WIN_SDK_INCLUDE_DIRECTORIES}//shared\\\""
   -isystem "\\\"${WIN_SDK_INCLUDE_DIRECTORIES}//winrt\\\""
   -isystem "\\\"${WIN_SDK_INCLUDE_DIRECTORIES}//cppwinrt\\\""
   -I\\\"${FREETYPE_INCLUDE_DIR}\\\"
   -I\\\"${GLFW_INCLUDE_DIR}\\\"
   -I\\\"${VULKAN_INCLUDE_DIRS}\\\"
   -I\\\"${VULKAN_INCLUDE_DIRSVKVideo}\\\"
   -I\\\"${GLAD_INCLUDE_DIR}\\\"
   -I\\\"${STB_INCLUDE_DIR}\\\"
   -I\\\"${GLEW_INCLUDE_DIR}\\\"
   -I\\\"${SDL2_INCLUDE_DIR}\\\"
   -I\\\"${SDL2_TTF_INCLUDE_DIR}\\\"
   -I\\\"${SDL2_IMAGE_INCLUDE_DIR}\\\"
   -I\\\"${SDL2_MIXER_INCLUDE_DIR}\\\"
   -I\\\"${BOOST_INCLUDE_DIR}\\\"
   -I\\\"${TINYENGINE_INCLUDE_DIR}\\\"
   -I\\\"${EIGEN_INCLUDE_DIR}\\\"
   -I\\\"${IMGUI_INCLUDE_DIR}\\\"
   -I\\\"${GLM_INCLUDE_DIR}\\\"
   -I\\\"${GLTEXT_INCLUDE_DIR}\\\"\"
   ignore\"
)

# Convert the list to a string with spaces between the options
string(REPLACE ";" " " common_compile_options_string "${common_compile_options}")

# Fonction pour vérifier le type de fichier
function(check_file_type FILENAME TYPE_VARIABLE)
    string(REGEX MATCH "\\.(cpp|hpp)$" IS_CPP_OR_HPP "${FILENAME}")
    set(${TYPE_VARIABLE} ${IS_CPP_OR_HPP} PARENT_SCOPE)
endfunction()

set(compile_commands "")
foreach(SOURCE_FILE ${SOURCES})
    # Vérifier le type de fichier
    check_file_type(${SOURCE_FILE} IS_CPP_OR_HPP_FILE)

    if (IS_CPP_OR_HPP_FILE)
        # Créer une chaîne JSON pour chaque fichier source .cpp ou .hpp
        string(APPEND compile_commands
            "    {\n"
            "        \"directory\": \"${build_directory}\",\n"
            "        \"command\": \"\\\"${CMAKE_CXX_COMPILER}\\\" -x c++ \\\"${SOURCE_FILE}\\\""
        )

        # Ajouter les options de compilation communes
        foreach(OPTION ${common_compile_options})
            if(NOT OPTION STREQUAL "ignore\"")
                string(APPEND compile_commands " ${OPTION}") 
            endif()
        endforeach()

        # Ajouter le reste de la commande et les métadonnées JSON
        string(APPEND compile_commands
            ",\n"
            "        \"file\": \"${SOURCE_FILE}\"\n"
            "    },\n"
        )
    endif()
endforeach()

# Éliminer la virgule finale
string(REGEX REPLACE ",\n$" "" compile_commands "${compile_commands}")

# Ajouter les crochets pour former une liste JSON
set(compile_commands "[\n${compile_commands}\n]")

# Écrire les entrées dans un fichier JSON
file(WRITE ${build_directory}/compile_commands.json "${compile_commands}")

# Ajoutez la cible personnalisée pour générer compile_commands.json
add_custom_target(generate_compile_commands
    DEPENDS ${build_directory}/compile_commands.json
    COMMENT "Generating compile_commands.json"
)
