#
# Defines dxc and dxil import libraries for Windows desktop builds.
#
# The add_dxc_runtime_dependencies() macro is used by halley-cmd to copy the
# runtime libraries alongside halley-cmd.exe.
#
if (WIN32)
    add_library(dxc SHARED IMPORTED GLOBAL)
    target_include_directories(
        dxc
        INTERFACE
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/dxc/inc
    )
    set_property(
        TARGET dxc
        PROPERTY IMPORTED_IMPLIB
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/dxc/lib/x64/dxcompiler.lib
    )
    set_property(
        TARGET dxc
        PROPERTY IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/dxc/bin/x64/dxcompiler.dll
    )
    add_library(dxil UNKNOWN IMPORTED GLOBAL)
    set_property(
        TARGET dxil
        PROPERTY IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/dxc/bin/x64/dxil.dll
    )
endif()

macro(add_dxc_runtime_dependencies target)
    if (WIN32)
        add_custom_command(
            TARGET
            ${target}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:dxc> $<TARGET_FILE_DIR:${target}>
        )
        add_custom_command(
            TARGET
            ${target}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:dxil> $<TARGET_FILE_DIR:${target}>
        )
    endif()
endmacro()
