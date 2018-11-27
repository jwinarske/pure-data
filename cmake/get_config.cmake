
include(CheckIncludeFiles)
include(CheckIncludeFile)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckTypeSize)

set(STDC_HEADERS
    sys/types.h
    sys/stat.h
    stdlib.h
    string.h
    memory.h
    strings.h
    inttypes.h
    stdint.h
    unistd.h
    dlfcn.h)

check_include_files("${STDC_HEADERS}" STDC_HEADERS)

check_include_file("fcntl.h" HAVE_FCNTL_H)
check_include_file("limits.h" HAVE_LIMITS_H)
check_include_file("malloc.h" HAVE_MALLOC_H)
check_include_file("netdb.h" HAVE_NETDB_H)
check_include_file("netinet/in.h" HAVE_NETINET_IN_H)
check_include_file("stddef.h" HAVE_STDDEF_H)
check_include_file("stdlib.h" HAVE_STDLIB_H)
check_include_file("string.h" HAVE_STRING_H)
check_include_file("sys/ioctl.h" HAVE_SYS_IOCTL_H)
check_include_file("sys/param.h" HAVE_SYS_PARAM_H)
check_include_file("sys/socket.h" HAVE_SYS_SOCKET_H)
check_include_file("sys/soundcard.h" HAVE_SYS_SOUNDCARD_H)
check_include_file("sys/time.h" HAVE_SYS_TIME_H)
check_include_file("sys/timeb.h" HAVE_SYS_TIMEB_H)
check_include_file("unistd.h" HAVE_UNISTD_H)
if(HAVE_UNISTD_H)
    add_definitions(-DHAVE_UNISTD_H)
endif()

check_type_size(int16_t INT16_T LANGUAGE C)
check_type_size(int32_t INT32_T LANGUAGE C)
check_type_size(off_t OFF_T LANGUAGE C)
check_type_size(pid_t PID_T LANGUAGE C)
check_type_size(size_t SIZE_T LANGUAGE C)

check_type_size("struct timespec" SIZEOF_TIMESPEC)
if(SIZEOF_TIMESPEC)
    set(HAVE_TIMESPEC 1)
endif()

check_include_file("alloca.h" HAVE_ALLOCA_H)
if(HAVE_ALLOCA_H)
    add_definitions(-DHAVE_ALLOCA)
else()
    check_symbol_exists(alloca "stdlib.h" HAVE_ALLOCA)
    if(HAVE_ALLOCA)
        add_definitions(-DHAVE_ALLOCA)
    endif()
endif()

check_function_exists(error_at_line HAVE_ERROR_AT_LINE)
check_function_exists(fork HAVE_FORK)
check_function_exists(vfork HAVE_VFORK)

check_function_exists(malloc HAVE_MALLOC)
check_function_exists(realloc HAVE_REALLOC)
check_function_exists(signal HAVE_SIGNAL)


check_function_exists(dup2 HAVE_DUP2)
check_function_exists(floor HAVE_FLOOR)
check_function_exists(getcwd HAVE_GETCWD)
check_function_exists(gethostbyname HAVE_GETHOSTBYNAME)
check_function_exists(gettimeofday HAVE_GETTIMEOFDAY)
check_function_exists(memmove HAVE_MEMMOVE)
check_function_exists(memset HAVE_MEMSET)
check_function_exists(pow HAVE_POW)
check_function_exists(regcomp HAVE_REGCOMP)
check_function_exists(select HAVE_SELECT)
check_function_exists(socket HAVE_SOCKET)
check_function_exists(sqrt HAVE_SQRT)
check_function_exists(strchr HAVE_STRCHR)
check_function_exists(strerror HAVE_STRERROR)
check_function_exists(strrchr HAVE_STRRCHR)
check_function_exists(strstr HAVE_STRSTR)
check_function_exists(strtol HAVE_STRTOL)


check_include_file("CoreAudio/CoreAudio.h" HAVE_COREAUDIO_H)
if(HAVE_COREAUDIO_H)
    add_definitions(-DUSEAPI_COREAUDIO)
endif()

check_include_file("bstring.h" HAVE_BSTRING_H)
if(HAVE_BSTRING_H)
    add_definitions(-DHAVE_BSTRING_H)
endif()

if(${CMAKE_DL_LIBS} MATCHES "dl")
    add_definitions(-DHAVE_LIBDL)
endif()


#################################
# Library Detection             #
#################################

set(CMAKE_THREAD_PREFER_PTHREAD ON)
include(FindThreads)

find_library(LIB_MATH NAMES m)
if(LIB_MATH MATCHES LIB_MATH-NOTFOUND)
    message(STATUS "LIB_MATH was not found..." )
    set(LIB_MATH "")
else()
    message(STATUS "Using LIB_MATH=${LIB_MATH}" )
endif()

find_library (LIB_ALSA NAMES asound)
if(LIB_ALSA MATCHES LIB_ALSA-NOTFOUND)
    message(STATUS "LIB_ALSA was not found..." )
    set(LIB_ALSA "")
else()
    set(USEAPI_ALSA ON)
    message(STATUS "Using LIB_ALSA=${LIB_ALSA}" )
endif()

# this hint needs to be more generic
find_library (LIB_OSS NAMES oss HINTS /usr/lib/x86_64-linux-gnu/ao/plugins-4)
if(LIB_OSS MATCHES LIB_OSS-NOTFOUND)
    message(STATUS "LIB_OSS was not found..." )
    set(LIB_OSS "")
else()
    set(USEAPI_OSS ON)
    message(STATUS "Using LIB_OSS=${LIB_OSS}" )
endif()

if(NOT USEAPI_ALSA AND 
   NOT USEAPI_AUDIOUNIT AND
   NOT USEAPI_ESD AND 
   NOT USEAPI_JACK AND
   NOT USEAPI_MMIO AND 
   NOT USEAPI_OSS AND 
   NOT USEAPI_PORTAUDIO
)
   set(USEAPI_DUMMY ON)
endif()
