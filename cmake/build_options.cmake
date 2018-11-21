
option(PD_BUILD_ASIO    "ASIO - build ASIO"               OFF)
option(PD_BUILD_PA      "PortAudio - build PortAudio"     OFF)
option(PD_BUILD_FFTW3   "FFTW3 - build FFTW3"             OFF)
option(PA_BUILD_EXTRAS  "Build Extras"                    ON)

message(" ")
message(STATUS "PD_BUILD_ASIO .......... ${PD_BUILD_ASIO}")
message(STATUS "PD_BUILD_PA ............ ${PD_BUILD_PA}")
message(STATUS "PD_BUILD_FFTW3 ......... ${PD_BUILD_FFTW3}")
message(STATUS "PD_BUILD_EXTRAS ........ ${PA_BUILD_EXTRAS}")

option(USEAPI_ALSA      "Use ALSA library for Audio"      OFF)
option(USEAPI_AUDIOUNIT "Use AudioUnit library for Audio" OFF)
option(USEAPI_ESD       "Use ESD library for Audio"       OFF)
option(USEAPI_JACK      "Use Jack library for Audio"      OFF)
option(USEAPI_MMIO      "Use MMIO library for Audio"      OFF)
option(USEAPI_OSS       "Use OSS library for Audio"       OFF)
option(USEAPI_PORTAUDIO "Use PortAudio library for Audio" OFF)

option(MIDI_ALSA        "Use ALSA Library for MIDI"       OFF)
option(MIDI_OSS         "Use OSS Library for MIDI"        OFF)
option(MIDI_PM          "Use PortMidi library for MIDI"   OFF)


#################################
# Implicit Behavior             #
#################################

if(PD_BUILD_PA)
    set(USEAPI_PORTAUDIO ON)
endif()

# ASIO...

#################################
# Override                      #
#################################

if(NOT USEAPI_ALSA AND NOT USEAPI_AUDIOUNIT AND
   NOT USEAPI_ESD  AND NOT USEAPI_JACK      AND
   NOT USEAPI_MMIO AND NOT USEAPI_OSS       AND 
   NOT USEAPI_PORTAUDIO)

    set(AUDIO_API_OVERRIDE OFF)
else()
    set(AUDIO_API_OVERRIDE ON)
endif()

if(NOT MIDI_ALSA AND NOT MIDI_OSS AND NOT MIDI_PM)
    set(MIDI_API_OVERRIDE OFF)
else()
    set(MIDI_API_OVERRIDE OFF)
endif()

message(STATUS "AUDIO_API_OVERRIDE ..... ${AUDIO_API_OVERRIDE}")
message(STATUS "MIDI_API_OVERRIDE ...... ${MIDI_API_OVERRIDE}")
message(" ")

#################################
# Misc                          #
#################################

# normalize a windows path
file(TO_CMAKE_PATH "${CMAKE_INSTALL_PREFIX}" CMAKE_INSTALL_PREFIX)
