cmake_minimum_required(VERSION 3.11)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "MinSizeRel" CACHE STRING "Choose the type of build, options are: Debug, Release, or MinSizeRel." FORCE)
    message(STATUS "CMAKE_BUILD_TYPE not set, defaulting to MinSizeRel.")
endif()

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/cmake")

include(get_version)
include(build_options)
include(build_dependencies)

project(pure-data VERSION "${PD_VERSION}" LANGUAGES C)

message(" ")
message(STATUS "Pure-Data Version ...... ${PROJECT_VERSION}")
message(STATUS "Generator .............. ${CMAKE_GENERATOR}")
message(STATUS "Build Type ............. ${CMAKE_BUILD_TYPE}")

include(get_config)
include(package_config)
message(" ")

#################################
# Source Files                  #
#################################
file(GLOB_RECURSE PD_D_SRC_FILES src/d*.c)
file(GLOB_RECURSE PD_G_SRC_FILES src/g*.c)
file(GLOB_RECURSE PD_M_SRC_FILES src/m*.c)
file(GLOB_RECURSE PD_X_SRC_FILES src/x*.c)

if(PD_BUILD_FFTW3)
    list(REMOVE_ITEM PD_D_SRC_FILES ${CMAKE_SOURCE_DIR}/src/d_fft_fftsg.c)
else()
    list(REMOVE_ITEM PD_D_SRC_FILES ${CMAKE_SOURCE_DIR}/src/d_fft_fftw.c)
endif()

include(system_files)

#################################
# Compile/Link Flags            #
#################################
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_definitions(-DPD -DPD_INTERNAL)

if(APPLE)
    set(CMAKE_MACOSX_RPATH ON)
endif()

#################################
# Dependent Directories         #
#################################
include_directories(src
    ${CMAKE_INSTALL_PREFIX}/include
    )

link_directories(${CMAKE_INSTALL_PREFIX}/lib)

#################################
# Static Library                #
#################################
add_library(pd_static STATIC
    ${PD_D_SRC_FILES} ${PD_G_SRC_FILES} ${PD_M_SRC_FILES}
    ${PD_S_SRC_FILES} ${PD_X_SRC_FILES}
    )
set_target_properties(pd_static  PROPERTIES
    OUTPUT_NAME pd
    )

#################################
# Shared Library                #
#################################
add_library(pd SHARED
    ${PD_D_SRC_FILES} ${PD_G_SRC_FILES} ${PD_M_SRC_FILES} 
    ${PD_S_SRC_FILES} ${PD_X_SRC_FILES}
    )

set(CMAKE_THREAD_PREFER_PTHREAD ON)
include(FindThreads)

find_library(LIB_MATH m)

target_link_libraries(pd PUBLIC 
    ${CMAKE_THREAD_LIBS_INIT} ${CMAKE_DL_LIBS}
    ${LIB_MATH} ${FFTW_LIBRARY} ${AUDIO_LIB}
    )

#################################
# Build Order Dependencies      #
#################################
if(PD_BUILD_FFTW3)
    add_dependencies(pd fftw3_ext)
    add_dependencies(pd_static fftw3_ext)
endif()

#################################
# Extras                        #
#################################
if(PA_BUILD_EXTRAS)
    include(build_extras)
endif()

#################################
# Utilities                     #
#################################
add_executable(pdsend src/u_pdsend.c)
add_executable(pdreceive src/u_pdreceive.c)

#################################
# Uninstall                     #
#################################
add_custom_target(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_SOURCE_DIR}/cmake/make_uninstall.cmake")
