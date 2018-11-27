
option(PD_BUILD_ASIO      "ASIO - build ASIO"               OFF)
option(PD_BUILD_PORTAUDIO "PortAudio - build PortAudio"     OFF)
option(PD_BUILD_FFTW3     "FFTW3 - build FFTW3"             OFF)
option(PD_BUILD_PORTMIDI  "PortMidi - build PortMidi"       OFF)
option(PD_BUILD_EXTRAS    "Build Extras"                    ON)

message(" ")
message(STATUS "PD_BUILD_ASIO .......... ${PD_BUILD_ASIO}")
message(STATUS "PD_BUILD_PORTAUDIO ..... ${PD_BUILD_PORTAUDIO}")
message(STATUS "PD_BUILD_FFTW3 ......... ${PD_BUILD_FFTW3}")
message(STATUS "PD_BUILD_PORTMIDI ...... ${PD_BUILD_PORTMIDI}")
message(STATUS "PD_BUILD_EXTRAS ........ ${PD_BUILD_EXTRAS}")

option(USEAPI_ALSA      "Use ALSA library for Audio"      OFF)
option(USEAPI_AUDIOUNIT "Use AudioUnit library for Audio" OFF)
option(USEAPI_ESD       "Use ESD library for Audio"       OFF)
option(USEAPI_JACK      "Use Jack library for Audio"      OFF)
option(USEAPI_MMIO      "Use MMIO library for Audio"      OFF)
option(USEAPI_OSS       "Use OSS library for Audio"       OFF)
option(USEAPI_PORTAUDIO "Use PortAudio library for Audio" OFF)
option(USEAPI_DUMMY     "Use Dummy impl for Audio"        OFF)

option(MIDI_ALSA        "Use ALSA Library for MIDI"       OFF)
option(MIDI_OSS         "Use OSS Library for MIDI"        OFF)
option(MIDI_PM          "Use PortMidi library for MIDI"   OFF)
option(MIDI_DUMMY       "Use Dummy impl for MIDI"         OFF)

#################################
# Implicit Behavior             #
#################################


#################################
# Implicit Behavior             #
#################################

if(PD_BUILD_ASIO)
    set(PD_BUILD_PORTAUDIO ON)
endif()

if(PD_BUILD_PORTAUDIO)
    set(USEAPI_PORTAUDIO ON)
endif()

#################################
# Misc                          #
#################################

# normalize a windows path
file(TO_CMAKE_PATH "${CMAKE_INSTALL_PREFIX}" CMAKE_INSTALL_PREFIX)
