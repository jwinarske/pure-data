include(CheckSymbolExists)
include(CheckIncludeFile)


if(${CMAKE_DL_LIBS})
    add_definitions(-DHAVE_LIBDL)
endif()

check_include_file("alloca.h" HAVE_ALLOCA_H)
if(HAVE_ALLOCA_H)
    add_definitions(-DHAVE_ALLOCA)
else()
    check_symbol_exists(alloca "stdlib.h;cstdlib" HAVE_ALLOCA)
    if(HAVE_ALLOCA)
        add_definitions(-DHAVE_ALLOCA)
    endif()
endif()

check_include_file("unistd.h" HAVE_UNISTD_H)
if(HAVE_UNISTD_H)
    add_definitions(-DHAVE_UNISTD_H)
endif()

check_include_file("bstring.h" HAVE_BSTRING_H)
if(HAVE_BSTRING_H)
    add_definitions(-DHAVE_BSTRING_H)
endif()


#################################
# Target Arch                   #
#################################
include (get_target_arch)
get_target_arch(TARGET_ARCH)
message(STATUS "Target ................. ${TARGET_ARCH}")
