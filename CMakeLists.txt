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

#################################
# Target Arch                   #
#################################
include (get_target_arch)
get_target_arch(TARGET_ARCH)
message(STATUS "Target ................. ${TARGET_ARCH}")

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

set(PD_SRC_FILES
    ${PD_D_SRC_FILES} ${PD_G_SRC_FILES}
    ${PD_M_SRC_FILES} ${PD_X_SRC_FILES}
    ${PD_S_SRC_FILES})

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
include_directories(src ${CMAKE_INSTALL_PREFIX}/include)

link_directories(${CMAKE_INSTALL_PREFIX}/lib)

#################################
# Static Library                #
#################################
add_library(libpd_static STATIC ${PD_SRC_FILES})

set_target_properties(libpd_static PROPERTIES OUTPUT_NAME pd)

#################################
# Linked Targets                #
#################################
set(CMAKE_THREAD_PREFER_PTHREAD ON)
include(FindThreads)

# needs a better solution
find_library(LIB_MATH m)

add_library(libpd SHARED ${PD_SRC_FILES})
target_link_libraries(libpd PUBLIC 
    ${CMAKE_THREAD_LIBS_INIT} ${CMAKE_DL_LIBS}
    ${LIB_MATH} ${FFTW_LIBRARY} ${AUDIO_LIB})

set_target_properties(libpd PROPERTIES OUTPUT_NAME pd)

add_executable(pd src/s_entry.c)
target_link_libraries(pd PUBLIC libpd_static
    ${CMAKE_THREAD_LIBS_INIT} ${CMAKE_DL_LIBS}
    ${LIB_MATH} ${FFTW_LIBRARY} ${AUDIO_LIB})

add_dependencies(pd libpd_static)

add_executable(pd-watchdog src/s_watchdog.c)
target_link_libraries(pd-watchdog PUBLIC libpd_static
    ${CMAKE_THREAD_LIBS_INIT} ${CMAKE_DL_LIBS}
    ${LIB_MATH} ${FFTW_LIBRARY} ${AUDIO_LIB})

add_dependencies(pd-watchdog libpd_static)

#################################
# Installation                  #
#################################
install(TARGETS pd libpd libpd_static
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib/static)

install(TARGETS pd 
        RUNTIME DESTINATION lib/pd/bin)

install(TARGETS pd-watchdog 
        RUNTIME DESTINATION lib/pd/bin)

install(FILES src/m_pd.h DESTINATION include)

install(DIRECTORY src/ DESTINATION include/pd
        FILES_MATCHING PATTERN "*.h")

install(FILES tcl/pd-gui.tcl DESTINATION lib/pd/tcl
        PERMISSIONS OWNER_WRITE OWNER_READ OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE)
        
install(DIRECTORY tcl DESTINATION lib/pd
        FILES_MATCHING PATTERN "*.tcl"
        PATTERN "pd-gui.tcl" EXCLUDE)

configure_file(tcl/pd-gui.in ${CMAKE_BINARY_DIR}/pd-gui @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/pd-gui
    DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    PERMISSIONS OWNER_WRITE OWNER_READ OWNER_EXECUTE
                GROUP_READ GROUP_EXECUTE
                WORLD_READ WORLD_EXECUTE)

install(DIRECTORY tcl DESTINATION lib/pd
        FILES_MATCHING PATTERN "*.gif")

install(DIRECTORY doc DESTINATION lib/pd
        FILES_MATCHING PATTERN "*"
        PATTERN "Makefile*" EXCLUDE
        PATTERN "makefile*" EXCLUDE
        PATTERN "*.c" EXCLUDE)

# leftoever from pd_extended, not used
#install(DIRECTORY DESTINATION lib/pd/startup/disabled)


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
if(PD_BUILD_EXTRAS)
    include(build_extras)
endif()

#################################
# Utilities                     #
#################################
add_executable(pdsend src/u_pdsend.c)
add_executable(pdreceive src/u_pdreceive.c)
install(TARGETS pdsend pdreceive RUNTIME DESTINATION bin)

#################################
# Uninstall                     #
#################################
add_custom_target(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_SOURCE_DIR}/cmake/make_uninstall.cmake")
