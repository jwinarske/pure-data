
include(ExternalProject)

IF(WIN32 AND PD_BUILD_ASIO)

    SET(ASIOSDK_VERSION 2.3.2)

    ExternalProject_Add(asio_ext
        URL http://www.steinberg.net/sdk_downloads/ASIOSDK${ASIOSDK_VERSION}.zip
        URL_HASH "SHA256=f8380b96cd64929986857466ef530572fabf755ba16a0693a37e4331a02fb692"
        PATCH_COMMAND cmake -E copy
            ${CMAKE_SOURCE_DIR}/cmake/asio/CMakeLists.txt
            ${CMAKE_SOURCE_DIR}/asio/ASIOSDK/CMakeLists.txt
        UPDATE_COMMAND ""
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/asio/ASIOSDK
        BUILD_IN_SOURCE 0
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
    )

    MESSAGE(STATUS "ASIO Installing to: ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}")
    SET(ASIO_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}/include/asio)
    SET(ASIO_LIBRARY_DIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}/lib)

    IF("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        SET(ASIO_LIBRARY "asiod.lib")
    ELSE()
        SET(ASIO_LIBRARY "asio.lib")
    endif()

ENDIF()

IF(PD_BUILD_PA)
    IF(NOT ANDROID)
        ExternalProject_Add(portaudio_ext
            GIT_REPOSITORY https://git.assembla.com/portaudio.git
            GIT_TAG master
            GIT_SHALLOW 1
            UPDATE_COMMAND ""
            BUILD_IN_SOURCE 0
            CMAKE_ARGS
            -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
            -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_VERBOSE_MAKEFILE=${CMAKE_VERBOSE_MAKEFILE}
            -DPA_ENABLE_DEBUG_OUTPUT=OFF
            -DPA_BUILD_EXAMPLES=OFF
            -DPA_BUILD_TESTS=OFF
            -DPA_DISABLE_INSTALL=OFF
        )
    ELSE()
        ExternalProject_Add(portaudio_ext
            GIT_REPOSITORY https://github.com/Gundersanne/portaudio_opensles.git
            GIT_TAG master
            GIT_SHALLOW 1
            UPDATE_COMMAND ""
            BUILD_IN_SOURCE 0
            CMAKE_ARGS
            -DANDROID_PLATFORM=${ANDROID_PLATFORM}
            -DANDROID_ABI=${ANDROID_ABI}
            -DANDROID_STL=${ANDROID_STL}
            -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
            -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_VERBOSE_MAKEFILE=${CMAKE_VERBOSE_MAKEFILE}
            -DPA_ENABLE_DEBUG_OUTPUT=OFF
            -DPA_BUILD_EXAMPLES=OFF
            -DPA_BUILD_TESTS=OFF
            -DPA_DISABLE_INSTALL=OFF
        )
    ENDIF()

    MESSAGE(STATUS "PortAudio Installing to: ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}")
    SET(PORTAUDIO_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}/include)
    SET(PORTAUDIO_LIBRARY_DIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}/lib)

    IF(MSVC)
        IF(${TARGET_ARCH} STREQUAL "x86_64")
            SET(_PORTAUDIO_LIB portaudio_x64)
        ELSE()
            SET(_PORTAUDIO_LIB portaudio_${TARGET_ARCH})
        ENDIF()
    ELSE()
        SET(_PORTAUDIO_LIB portaudio)
    ENDIF()

ENDIF()


IF(PD_BUILD_FTTW)

    SET(FTTW_VERSION 3.3.8)

    ExternalProject_Add(fftw_ext
        URL http://www.fftw.org/fftw-${FTTW_VERSION}.tar.gz
        URL_HASH "SHA256=6113262f6e92c5bd474f2875fa1b01054c4ad5040f6b0da7c03c98821d9ae303"
        UPDATE_COMMAND ""
        BUILD_IN_SOURCE 0
        CMAKE_ARGS
        -DANDROID_PLATFORM=${ANDROID_PLATFORM}
        -DANDROID_ABI=${ANDROID_ABI}
        -DANDROID_STL=${ANDROID_STL}
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_VERBOSE_MAKEFILE=${CMAKE_VERBOSE_MAKEFILE}
    )

    MESSAGE(STATUS "FFTW Installing to: ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}")
    SET(FFTW_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}/include)
    SET(FFTW_LIBRARY_DIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_BUILD_TYPE}/lib)

    IF(WIN32)
        IF("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
            SET(FFTW_LIBRARY fftw3d.lib)
        ELSE()
            SET(FFTW_LIBRARY fftw3.lib)
        ENDIF()
    ELSE()
        SET(FFTW_LIBRARY fftw3)
    ENDIF()

ENDIF()
