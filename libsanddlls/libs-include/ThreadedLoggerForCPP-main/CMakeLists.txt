cmake_minimum_required(VERSION 3.28)
project(ThreadedLoggerForCPP VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)
enable_testing()

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD")

# Enable LTO Optimizations(Link-Time Optimization) 
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)

# Set common directories
set(DLL_DIR "${CMAKE_SOURCE_DIR}/libsanddlls/dlls")
set(LIB_DIR "${CMAKE_SOURCE_DIR}/libsanddlls/libs")
set(LIBRAIRIES_DIR "${CMAKE_SOURCE_DIR}")
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")

# Find source files
file(GLOB_RECURSE SOURCES "${SRC_DIR}/*.cpp" "${SRC_DIR}/*.h" "${SRC_DIR}/*.hpp")

set(SOURCES_FILES ${SOURCES})

# External libraries include directories
set(ALL_INCLUDE_DIR
"${LIBRAIRIES_DIR}/libs/include"
)

# Add executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Target include directories
target_include_directories(${PROJECT_NAME} PUBLIC ${ALL_INCLUDE_DIR})


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
