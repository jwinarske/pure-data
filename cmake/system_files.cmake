
set(PD_S_SRC_FILES
    src/s_audio_paring.c
    src/s_audio.c
    src/s_entry.c
    src/s_file.c
    src/s_inter.c
    src/s_loader.c
    src/s_main.c
    src/s_path.c
    src/s_print.c
    src/s_utf8.c
)

if(USEAPI_PORTAUDIO)
    list(APPEND PD_S_SRC_FILES src/s_audio_pa.c)
    set(AUDIO_LIB portaudio)
elseif(USEAPI_ALSA)
    list(APPEND PD_S_SRC_FILES src/s_audio_alsa.c)
    list(APPEND PD_S_SRC_FILES src/s_audio_alsamm.c)
    set(AUDIO_LIB asound)
elseif(USEAPI_OSS)
    list(APPEND PD_S_SRC_FILES src/s_audio_oss.c)
    set(AUDIO_LIB oss)
elseif(USEAPI_JACK)
    list(APPEND PD_S_SRC_FILES src/s_audio_jack.c)
    set(AUDIO_LIB jack)
elseif(USEAPI_MMIO)
    list(APPEND PD_S_SRC_FILES src/s_audio_mmio.c)
    set(AUDIO_LIB mmio)
elseif(USEAPI_AUDIOUNIT)
    list(APPEND PD_S_SRC_FILES src/s_audio_audiounit.c)
    set(AUDIO_LIB audiounit)
elseif(USEAPI_ESD)
    list(APPEND PD_S_SRC_FILES src/s_audio_esd.c)
    set(AUDIO_LIB esd)
else()
    list(APPEND PD_S_SRC_FILES src/s_audio_dummy.c)
    set(AUDIO_LIB )
endif()


if(MIDI_ALSA)
    list(APPEND PD_S_SRC_FILES src/s_midi_alsa.c)
elseif(MIDI_OSS)
    list(APPEND PD_S_SRC_FILES src/s_midi_oss.c)
elseif(MIDI_PM)
    list(APPEND PD_S_SRC_FILES src/s_midi_pm.c)
else()
    list(APPEND PD_S_SRC_FILES src/s_midi_dummy.c)
endif()
