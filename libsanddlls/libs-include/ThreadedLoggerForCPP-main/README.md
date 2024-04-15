# Note this code is not terminated at 100% , i need to do somethings

# ThreadedLoggerForCPP
A separate thread for logging for c++ projects

See main.cpp in src/ to see code example to how to use in .cpp files

how to include this library int your project :

1 : Download the latest Release from Github

2 : copy and paste the whole code into YOUR_LIBS_FOLDER 

1 : Add these lines into your CMakeLists.txt

set(LIBRAIRIES_DIR "${CMAKE_SOURCE_DIR}/YOUR_LIBS_FOLDER")

set(ALL_INCLUDE_DIR "${LIBRAIRIES_DIR}/ThreadedLoggerForCPP-VersionX.X/include")

target_include_directories(${PROJECT_NAME} PUBLIC ${ALL_INCLUDE_DIR})
