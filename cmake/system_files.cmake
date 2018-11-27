
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
    list(APPEND PD_S_SRC_FILES src/s_midi_pm.c)
    add_definitions(-DUSEAPI_PORTAUDIO)
    list(APPEND AUDIO_LIB ${LIB_PORTAUDIO})
endif()
if(USEAPI_ALSA)
    list(APPEND PD_S_SRC_FILES src/s_audio_alsa.c)
    list(APPEND PD_S_SRC_FILES src/s_audio_alsamm.c)
    list(APPEND PD_S_SRC_FILES src/s_midi_alsa.c)
    add_definitions(-DUSEAPI_ALSA)
    list(APPEND AUDIO_LIB ${LIB_ALSA})
endif()
if(USEAPI_OSS)
    list(APPEND PD_S_SRC_FILES src/s_audio_oss.c)
    list(APPEND PD_S_SRC_FILES src/s_midi_oss.c)
    add_definitions(-DUSEAPI_OSS)
    list(APPEND AUDIO_LIB ${LIB_OSS})
endif()
if(USEAPI_JACK)
    list(APPEND PD_S_SRC_FILES src/s_audio_jack.c)
    add_definitions(-DUSEAPI_JACK)
    list(APPEND AUDIO_LIB jack)
endif()
if(USEAPI_MMIO)
    list(APPEND PD_S_SRC_FILES src/s_audio_mmio.c)
    add_definitions(-DUSEAPI_MMIO)
    list(APPEND AUDIO_LIB mmio)
endif()
if(USEAPI_AUDIOUNIT)
    list(APPEND PD_S_SRC_FILES src/s_audio_audiounit.c)
    add_definitions(-DUSEAPI_AUDIOUNIT)
    list(APPEND AUDIO_LIB audiounit)
endif()
if(USEAPI_ESD)
    list(APPEND PD_S_SRC_FILES src/s_audio_esd.c)
    add_definitions(-DUSEAPI_ESD)
    list(APPEND AUDIO_LIB esd)
endif()
if(USEAPI_DUMMY)
    list(APPEND PD_S_SRC_FILES src/s_audio_dummy.c)
    list(APPEND PD_S_SRC_FILES src/s_midi_dummy.c)
    add_definitions(-DUSEAPI_DUMMY)
endif()
