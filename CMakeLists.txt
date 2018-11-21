cmake_minimum_required(VERSION 3.11)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "MinSizeRel" CACHE STRING "Choose the type of build, options are: Debug, Release, or MinSizeRel." FORCE)
    message(STATUS "CMAKE_BUILD_TYPE not set, defaulting to MinSizeRel.")
endif()

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/cmake")

include (get_version)

message(STATUS "Generator .............. ${CMAKE_GENERATOR}")
message(STATUS "Build Type ............. ${CMAKE_BUILD_TYPE}")

include(build_options)
include(build_dependencies)

project(pure-data VERSION "${PD_VERSION}" LANGUAGES C)
message(STATUS "Pure-Data Version ...... ${PROJECT_VERSION}")

include(get_config)

file(GLOB_RECURSE PD_D_SRC_FILES src/d*.c)

if(PD_BUILD_FTTW)
    list(REMOVE_ITEM PD_D_SRC_FILES ${CMAKE_SOURCE_DIR}/src/d_fft_fftsg.c)
else()
    list(REMOVE_ITEM PD_D_SRC_FILES ${CMAKE_SOURCE_DIR}/src/d_fft_fftw.c)
endif()

file(GLOB_RECURSE PD_G_SRC_FILES src/g*.c)
file(GLOB_RECURSE PD_M_SRC_FILES src/m*.c)
file(GLOB_RECURSE PD_X_SRC_FILES src/x*.c)

include(system_files)


include_directories(src)

set(CMAKE_THREAD_PREFER_PTHREAD ON)
include(FindThreads)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
add_definitions(-DPD -DPD_INTERNAL)

if(APPLE)
    set(CMAKE_MACOSX_RPATH ON)
endif()


add_library(pd SHARED
    ${PD_D_SRC_FILES} ${PD_G_SRC_FILES} ${PD_M_SRC_FILES} 
    ${PD_S_SRC_FILES} ${PD_X_SRC_FILES}
)

add_library(pd_static STATIC
    ${PD_D_SRC_FILES} ${PD_G_SRC_FILES} ${PD_M_SRC_FILES}
    ${PD_S_SRC_FILES} ${PD_X_SRC_FILES}
)


find_library(LIB_MATH m)

include_directories(${CMAKE_INSTALL_PREFIX}/include)
link_directories(${CMAKE_INSTALL_PREFIX}/lib)
target_link_libraries(pd PUBLIC 
    ${FFTW_LIBRARY}
    ${CMAKE_THREAD_LIBS_INIT}
    ${LIB_MATH}
    ${CMAKE_DL_LIBS}
    ${AUDIO_LIB}
)

add_executable(pdsend src/u_pdsend.c)
add_executable(pdreceive src/u_pdreceive.c)


add_custom_target(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_SOURCE_DIR}/cmake/make_uninstall.cmake")
