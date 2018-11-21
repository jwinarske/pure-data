
set(PACKAGE_NAME "pd")
set(PACKAGE_TARNAME "${PACKAGE_NAME}")
set(PACKAGE_VERSION "${PROJECT_VERSION}")
set(PACKAGE_STRING "${PACKAGE_NAME} ${PROJECT_VERSION}")
set(PACKAGE_BUGREPORT "")
set(PACKAGE_URL "")
set(PACKAGE "${PACKAGE_NAME}")
set(VERSION "${PROJECT_VERSION}")
set(prefix ${CMAKE_INSTALL_PREFIX})

set(exec_prefix )
set(libdir ${CMAKE_INSTALL_PREFIX}/lib)
set(includedir ${CMAKE_INSTALL_PREFIX}/include)

set(EXTERNAL_CFLAGS ${CMAKE_C_FLAGS})
set(EXTERNAL_LDFLAGS ${CMAKE_EXE_LINKER_FLAGS})

#
# d_fat
# pd_linux
# dll
# pd_openbsd
# pd_darwin
#

if(CMAKE_HOST_SYSTEM_NAME MATCHES "OpenBSD")
    set(EXTERNAL_EXTENSION ".pd_openbsd")
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin")
    set(EXTERNAL_EXTENSION ".pd_darwin")
else()
    set(EXTERNAL_EXTENSION ".pd_linux")
endif()


configure_file(pd.pc.in ${CMAKE_BINARY_DIR}/pd.pc @ONLY)