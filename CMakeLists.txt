cmake_minimum_required(VERSION 3.10)
project(LunarLib VERSION 1.0 LANGUAGES CXX)
set(CMAKE_VERBOSE_MAKEFILE ON)


# Specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set the default value for CMAKE_INSTALL_PREFIX
# This assumes 'lunar' is a sibling directory to the build directory
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../lunar" CACHE PATH "Default install prefix" FORCE)


# Options for building as a DLL and targeting 32-bit architecture
option(BUILD_AS_DLL "Build the library as a DLL." OFF)
option(TARGET_32_BIT "Target 32-bit architecture." OFF)

# Define output directories based on architecture and build type
# Determine architecture directory based on processor architecture and pointer size
if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|ARM64)$")
    set(ARCH_DIR "arm64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(amd64|x86_64)$")
    set(ARCH_DIR "x64")
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
    # Fallback for other 64-bit architectures without explicit matches above
    set(ARCH_DIR "x64")
else()
    set(ARCH_DIR "x86") # Default to x86 for 32-bit architectures
endif()


# Use generator expressions to handle different configurations (Debug, Release, etc.)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${ARCH_DIR}/$<CONFIG>/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${ARCH_DIR}/$<CONFIG>/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${ARCH_DIR}/$<CONFIG>/bin)


# Compiler flags common to all builds
if(MSVC)
    set(COMMON_FLAGS "/W3" "/EHsc" "/D_CRT_SECURE_NO_WARNINGS")
    # Add /MT only if BUILD_AS_DLL is OFF
    if(NOT BUILD_AS_DLL)
        list(APPEND COMMON_FLAGS "/MT")
    endif()
else()
    set(COMMON_FLAGS "-Wall" "-Wextra" "-pedantic" "-O2" "-D_CRT_SECURE_NO_WARNINGS")
endif()

# Include directories
include_directories(${PROJECT_SOURCE_DIR}/src)

# Source files for the lunar library
# file(GLOB LIB_SOURCES "src/*.cpp" "src/*.c")
set(LIB_SOURCES
    src/ades2mpc.cpp
    src/alt_az.cpp
    src/astfuncs.cpp
    src/big_vsop.cpp
    src/brentmin.cpp
    src/classel.cpp
    src/com_file.cpp
    src/conbound.c
    src/cospar.cpp
    src/date.cpp
    src/de_plan.cpp
    src/delta_t.cpp
    src/dist_pa.cpp
    src/elp82dat.cpp
    src/eop_prec.cpp
    src/getplane.cpp
    src/get_time.cpp
    src/jsats.cpp
    src/lunar2.cpp
    src/miscell.cpp
    src/mpc_code.cpp
    src/mpc_fmt.cpp
    src/mpc_fmt2.cpp
    src/moid.cpp
    src/nanosecs.cpp
    src/nutation.cpp
    src/obliquit.cpp
    src/pluto.cpp
    src/precess.cpp
    src/refract.cpp
    src/refract4.cpp
    src/rocks.cpp
    src/showelem.cpp
    src/sof.cpp
    src/snprintf.cpp
    src/spline.cpp
    src/ssats.cpp
    src/unpack.cpp
    src/triton.cpp
    src/vislimit.cpp
    src/vsopson.cpp
    # Add more source files as needed
)

# Determine library name based on options
if(TARGET_32_BIT)
    set(LIBNAME "lunar")
else()
    set(LIBNAME "lunar64")
endif()

# Add library target
if(BUILD_AS_DLL)
    add_library(${LIBNAME} SHARED ${LIB_SOURCES})
    target_compile_definitions(${LIBNAME} PRIVATE LUNARLIB_EXPORTS)
else()
    add_library(${LIBNAME} STATIC ${LIB_SOURCES})
endif()

# Apply common compiler flags
target_compile_options(${LIBNAME} PRIVATE ${COMMON_FLAGS})

# Demo executable targets
# Below is an example for a couple of demos, repeat the pattern for all required executables
# add_executable(add_off src/add_off.c)
# target_link_libraries(add_off PRIVATE ${LIBNAME})


# add_executable(adestest src/adestest.cpp src/mpc_fmt2.cpp)
# target_link_libraries(adestest PRIVATE ${LIBNAME})

# Specify additional link libraries for specific executables if needed
# For example, if 'add_off' requires 'urlmon.lib' on Windows:
if(WIN32)
    # target_link_libraries(add_off PRIVATE urlmon)
endif()

# Installation rules for the library and public headers
#install(TARGETS ${LIBNAME} DESTINATION lib)

# Adjust the install prefix to point to the desired directory
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../lunar")

# Specify the installation rules for the target
install(TARGETS ${LIBNAME}
        ARCHIVE DESTINATION build/${ARCH_DIR}/Release/lib
        LIBRARY DESTINATION build/${ARCH_DIR}/Release/lib
        RUNTIME DESTINATION build/${ARCH_DIR}/Release/bin)

# Install headers
install(DIRECTORY ${PROJECT_SOURCE_DIR}/src/ DESTINATION include)



# Note: For executable targets that require specific source files like `oblitest`,
# you will need to list those source files explicitly in `add_executable()`.
