
set(PD_S_SRC_FILES
    src/s_audio.c
    src/s_audio_paring.c
    src/s_file.c
    src/s_inter.c
    src/s_loader.c
    src/s_main.c
    src/s_midi.c
    src/s_path.c
    src/s_print.c
    src/s_utf8.c
)

if(USEAPI_PORTAUDIO)
    list(APPEND PD_S_SRC_FILES src/s_audio_pa.c)
    add_definitions(-DUSEAPI_PORTAUDIO)
    set(AUDIO_LIB portaudio)
endif()
if(USEAPI_ALSA)
    list(APPEND PD_S_SRC_FILES src/s_audio_alsa.c)
    list(APPEND PD_S_SRC_FILES src/s_audio_alsamm.c)
    add_definitions(-DUSEAPI_ALSA)
    set(AUDIO_LIB asound)
endif()
if(USEAPI_OSS)
    list(APPEND PD_S_SRC_FILES src/s_audio_oss.c)
    add_definitions(-DUSEAPI_OSS)
    set(AUDIO_LIB oss)
endif()
if(USEAPI_JACK)
    list(APPEND PD_S_SRC_FILES src/s_audio_jack.c)
    add_definitions(-DUSEAPI_JACK)
    set(AUDIO_LIB jack)
endif()
if(USEAPI_MMIO)
    list(APPEND PD_S_SRC_FILES src/s_audio_mmio.c)
    add_definitions(-DUSEAPI_MMIO)
    set(AUDIO_LIB mmio)
endif()
if(USEAPI_AUDIOUNIT)
    list(APPEND PD_S_SRC_FILES src/s_audio_audiounit.c)
    add_definitions(-DUSEAPI_AUDIOUNIT)
    set(AUDIO_LIB audiounit)
endif()
if(USEAPI_ESD)
    list(APPEND PD_S_SRC_FILES src/s_audio_esd.c)
    add_definitions(-DUSEAPI_ESD)
    set(AUDIO_LIB esd)
endif()
if(USEAPI_DUMMY)
    list(APPEND PD_S_SRC_FILES src/s_audio_dummy.c)
    add_definitions(-DUSEAPI_DUMMY)
endif()


if(MIDI_ALSA)
    list(APPEND PD_S_SRC_FILES src/s_midi_alsa.c)
endif()
if(MIDI_OSS)
    list(APPEND PD_S_SRC_FILES src/s_midi_oss.c)
endif()
if(MIDI_PM)
    list(APPEND PD_S_SRC_FILES src/s_midi_pm.c)
endif()
if(MIDI_DUMMY)
    list(APPEND PD_S_SRC_FILES src/s_midi_dummy.c)
endif()
