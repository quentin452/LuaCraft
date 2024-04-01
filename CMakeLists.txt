cmake_minimum_required(VERSION 3.28)
project(LUACRAFT)

add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD")

# Enable LTO Optimizations(Link-Time Optimization) 
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)

# Set common directories
set(DLL_DIR "${CMAKE_SOURCE_DIR}/libsanddlls/dlls")
set(LIB_DIR "${CMAKE_SOURCE_DIR}/libsanddlls/libs")
set(LIBRAIRIES_DIR "${CMAKE_SOURCE_DIR}/libsanddlls/libs-include")
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")

# Find source files
file(GLOB_RECURSE SOURCES "${SRC_DIR}/*.cpp" "${SRC_DIR}/*.h" "${SRC_DIR}/*.hpp")

set(SOURCES_FILES ${SOURCES})

# External libraries include directories
set(ALL_INCLUDE_DIR
    "${LIBRAIRIES_DIR}/freetype-2.8.1/include"
    "${LIBRAIRIES_DIR}/glfw-3.4.bin.WIN64/include"
    "${LIBRAIRIES_DIR}/Vulkan-Headers-main/include/vulkan"
    "${LIBRAIRIES_DIR}/Vulkan-Headers-main/include/vk_video"
    "${LIBRAIRIES_DIR}/glad/include/glad"
    "${LIBRAIRIES_DIR}/stb"
    "${LIBRAIRIES_DIR}/glew-2.1.0/include"
    "${LIBRAIRIES_DIR}/gltext"
    "${LIBRAIRIES_DIR}/SDL2-2.30.1/include"
    "${LIBRAIRIES_DIR}/SDL2_ttf-2.22.0"
    "${LIBRAIRIES_DIR}/SDL2_image-2.8.2/include"
    "${LIBRAIRIES_DIR}/SDL2_mixer-2.8.0/include"
    "${LIBRAIRIES_DIR}/boost_1_85_0"
    "${LIBRAIRIES_DIR}/TinyEngine-master"
    "${LIBRAIRIES_DIR}/glm-1.0.1-light/glm"
    "${LIBRAIRIES_DIR}/eigen-3.4.0"
    "${LIBRAIRIES_DIR}/imgui-x"
)

# External libraries libraries directories
file(GLOB ALL_LIBRARIES_DIR "${LIB_DIR}/*.lib")


set(BOOST_LIBRARY_DIR "${LIBRAIRIES_DIR}/boost_1_85_0/stage/lib")
file(GLOB BOOST_LIBRARIES "${BOOST_LIBRARY_DIR}/*.lib")

# Add executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Target include directories
target_include_directories(${PROJECT_NAME} PUBLIC ${ALL_INCLUDE_DIR})

# Create a list of DLLs to copy
file(GLOB DLL_LIST "${DLL_DIR}/*.dll")

# Copy DLLs after build if they don't exist already
foreach(DLL ${DLL_LIST})
    file(TO_NATIVE_PATH "${DLL}" NATIVE_DLL_PATH)
    get_filename_component(DLL_NAME "${DLL}" NAME)
    set(DESTINATION_PATH "$<TARGET_FILE_DIR:${PROJECT_NAME}>/${DLL_NAME}")
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${NATIVE_DLL_PATH}"
        "${DESTINATION_PATH}"
        VERBATIM
        )
endforeach()

# Link libraries
target_link_libraries(${PROJECT_NAME} PRIVATE ${ALL_LIBRARIES_DIR} ${BOOST_LIBRARIES})

# Common compilation options
set(common_compile_options
   -std=c++${CMAKE_CXX_STANDARD}
   -Wall 
   -compilerandversion=${CMAKE_CXX_COMPILER_ID}-${CMAKE_CXX_COMPILER_VERSION}
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
)

# Add each include directory to the compilation options
foreach(INCLUDE_DIR ${ALL_INCLUDE_DIR})
    list(APPEND common_compile_options -I\\\"${INCLUDE_DIR}\\\")
endforeach()

# Add an extra quote to the last element
list(LENGTH ALL_INCLUDE_DIR INCLUDE_DIR_COUNT)
math(EXPR LAST_INDEX "${INCLUDE_DIR_COUNT} - 1")
list(GET ALL_INCLUDE_DIR ${LAST_INDEX} LAST_INCLUDE_DIR)
string(CONCAT LAST_INCLUDE_DIR_WITH_QUOTE ${LAST_INCLUDE_DIR} "\"")
list(POP_BACK common_compile_options)
list(APPEND common_compile_options ${LAST_INCLUDE_DIR_WITH_QUOTE})

# Convert the list to a string with spaces between the options
string(REPLACE ";" " " common_compile_options_string "${common_compile_options}")

# Filter the source files to keep only .cpp and .hpp files
list(FILTER SOURCES INCLUDE REGEX "\\.(cpp|hpp)$")

set(compile_commands "")
foreach(SOURCE_FILE ${SOURCES})
    # Create a JSON string for each .cpp or .hpp source file
    string(APPEND compile_commands
        "    {\n"
        "        \"directory\": \"${CMAKE_CURRENT_BINARY_DIR}\",\n"
        "        \"command\": \"\\\"${CMAKE_CXX_COMPILER}\\\" -x c++ \\\"${SOURCE_FILE}\\\""
    )

    # Add the common compile options
    foreach(OPTION ${common_compile_options})
        string(APPEND compile_commands " ${OPTION}") 
    endforeach()

    # Add the rest of the command and JSON metadata
    string(APPEND compile_commands
        ",\n"
        "        \"file\": \"${SOURCE_FILE}\"\n"
        "    },\n"
    )
endforeach()

# Remove the final comma
string(REGEX REPLACE ",\n$" "" compile_commands "${compile_commands}")

# Add brackets to form a JSON list
set(compile_commands "[\n${compile_commands}\n]")

# Write the entries to a JSON file
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json "${compile_commands}")

# Add the custom target to generate compile_commands.json
add_custom_target(generate_compile_commands
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json
    COMMENT "Generating compile_commands.json"
)
