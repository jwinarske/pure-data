
macro(get_extra_filtered_lists proj path)

    file(GLOB ${proj}_headers ${path}/*.h)
    file(GLOB ${proj}_src ${path}/*.c)
    file(GLOB ${proj}_patches ${path}/*.pd)

endmacro(get_extra_filtered_lists)

macro(extra_add_lib project proj path)

    get_extra_filtered_lists(${proj} ${path})

    if(${proj}_src)
        message(STATUS "Extra: ${project}")
        add_library(${proj}_lib SHARED ${${proj}_src} ${${proj}_headers})
        add_library(${proj}_staticlib STATIC ${${proj}_src} ${${proj}_headers})
        install(TARGETS ${proj}_lib ${proj}_staticlib 
            LIBRARY DESTINATION lib/pd/extra/${project}
            ARCHIVE DESTINATION lib/pd/extra/${project})
    endif()

endmacro(extra_add_lib)

file(GLOB extra_projects LIST_DIRECTORIES true extra/*)
foreach(path ${extra_projects})
    if(IS_DIRECTORY ${path})
        get_filename_component(project ${path} NAME)
        string(REPLACE "~" "_" proj ${project})
        extra_add_lib(${project} ${proj} ${path})
        set_target_properties(${proj}_lib PROPERTIES
            PREFIX ""
            SUFFIX ${EXTERNAL_EXTENSION}
            OUTPUT_NAME ${project}
            )
        set_target_properties(${proj}_staticlib PROPERTIES
            PREFIX ""
            SUFFIX ".la" # todo - unique per target...
            OUTPUT_NAME ${project}
            )
    endif()
endforeach(path)

install(DIRECTORY extra DESTINATION lib/pd
    FILES_MATCHING PATTERN "*.pd")

message(" ")