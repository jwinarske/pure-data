
option(PD_BUILD_ASIO "ASIO - build ASIO" OFF)
option(PD_BUILD_PA   "PortAudio - build PortAudio" OFF)
option(PD_BUILD_FFTW "FFTW - build FFTW" OFF)
option(PA_BUILD_EXTRAS "Build Extras" ON)

message(STATUS "PD_BUILD_ASIO .......... ${PD_BUILD_ASIO}")
message(STATUS "PD_BUILD_PA ............ ${PD_BUILD_PA}")
message(STATUS "PD_BUILD_FFTW .......... ${PD_BUILD_FFTW}")


option(USEAPI_ALSA "Use ALSA library for Audio" OFF)
option(USEAPI_AUDIOUNIT "Use AudioUnit library for Audio" OFF)
option(USEAPI_ESD "Use ESD library for Audio" OFF)
option(USEAPI_JACK "Use Jack library for Audio" OFF)
option(USEAPI_MMIO "Use MMIO library for Audio" OFF)
option(USEAPI_OSS "Use OSS library for Audio" OFF)
option(USEAPI_PORTAUDIO "Use PortAudio library for Audio" ON)

#option(MIDI_ALSA "Use ALSA Library for MIDI" ON)
option(MIDI_OSS "Use OSS Library for MIDI" OFF)
option(MIDI_PM "Use PortMidi library for MIDI" OFF)


if(PD_BUILD_PA)
    set(USEAPI_PORTAUDIO ON)
endif()


# normalize a windows path
file(TO_CMAKE_PATH "${CMAKE_INSTALL_PREFIX}" CMAKE_INSTALL_PREFIX)
