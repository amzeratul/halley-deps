#
# Defines import library targets for the DirectX shader compiler (dxc) and its
# runtime dependencies for Windows.
#
# If the Xbox GDK installation is present, targets for its compiler variants
# are picked up too, to enable shader precompilation on Xbox One and Scarlett.
#
# The add_dxc_runtime_dependencies() macro is used by halley-cmd to copy all
# runtime libraries next to halley-cmd.exe as a post-build step.
#
if (WIN32)
    # dxcompiler.lib and dxcompiler.dll
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
    # dxil.dll
    add_library(dxil UNKNOWN IMPORTED GLOBAL)
    set_property(
        TARGET dxil
        PROPERTY IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/dxc/bin/x64/dxil.dll
    )

    if (EXISTS "$ENV{GXDKLatest}gameKit/Include/XboxOne/dxcapi_x.h" AND
        EXISTS "$ENV{GXDKLatest}gameKit/symbols/XboxOne/dxcompiler_x.dll" AND
        EXISTS "$ENV{GXDKLatest}gameKit/symbols/XboxOne/sc_dll.dll" AND
        EXISTS "$ENV{GXDKLatest}gameKit/symbols/XboxOne/scdxil.dll" AND
        EXISTS "$ENV{GXDKLatest}gameKit/symbols/XboxOne/newbe.dll")
        # dxcompiler_x.lib and dxcompiler_x.dll
        add_library(dxc_x UNKNOWN IMPORTED GLOBAL)
        target_include_directories(
            dxc_x
            INTERFACE
            $ENV{GXDKLatest}gameKit/Include/XboxOne
        )
        set_property(
            TARGET dxc_x
            PROPERTY IMPORTED_LOCATION
            $ENV{GXDKLatest}gameKit/symbols/XboxOne/dxcompiler_x.dll
        )
        # sc_dll.dll, scdxil.dll, newbe.dll
        # The compiler runtime seems to load all three of them.
        add_library(scdll_x UNKNOWN IMPORTED GLOBAL)
        set_property(
            TARGET scdll_x
            PROPERTY IMPORTED_LOCATION
            $ENV{GXDKLatest}gameKit/symbols/XboxOne/sc_dll.dll
        )
        add_library(scdxil_x UNKNOWN IMPORTED GLOBAL)
        set_property(
            TARGET scdxil_x
            PROPERTY IMPORTED_LOCATION
            $ENV{GXDKLatest}gameKit/symbols/XboxOne/scdxil.dll
        )
        add_library(newbe_x UNKNOWN IMPORTED GLOBAL)
        set_property(
            TARGET newbe_x
            PROPERTY IMPORTED_LOCATION
            $ENV{GXDKLatest}gameKit/symbols/XboxOne/newbe.dll
        )
        set(DXC_X_FOUND 1)
    else()
        set(DXC_X_FOUND 0)
    endif()

    if (EXISTS "$ENV{GXDKLatest}gameKit/Include/Scarlett/dxcapi_xs.h" AND
        EXISTS "$ENV{GXDKLatest}gameKit/symbols/Scarlett/dxcompiler_xs.dll" AND
        EXISTS "$ENV{GXDKLatest}gameKit/symbols/Scarlett/xbsc_xs.dll" AND
        EXISTS "$ENV{GXDKLatest}gameKit/symbols/Scarlett/newbe_xs.dll")
        # dxcompiler_xs.lib and dxcompiler_xs.dll
        add_library(dxc_xs UNKNOWN IMPORTED GLOBAL)
        target_include_directories(
            dxc_xs
            INTERFACE
            $ENV{GXDKLatest}gameKit/Include/Scarlett
        )
        set_property(
            TARGET dxc_xs
            PROPERTY IMPORTED_LOCATION
            $ENV{GXDKLatest}gameKit/symbols/Scarlett/dxcompiler_xs.dll
        )
        # xbsc_xs.dll, newbe_xs.dll
        add_library(xbsc_xs UNKNOWN IMPORTED GLOBAL)
        set_property(
            TARGET xbsc_xs
            PROPERTY IMPORTED_LOCATION
            $ENV{GXDKLatest}gameKit/symbols/Scarlett/xbsc_xs.dll
        )
        add_library(newbe_xs UNKNOWN IMPORTED GLOBAL)
        set_property(
            TARGET newbe_xs
            PROPERTY IMPORTED_LOCATION
            $ENV{GXDKLatest}gameKit/symbols/Scarlett/newbe_xs.dll
        )
        set(DXC_XS_FOUND 1)
    else()
        set(DXC_XS_FOUND 0)
    endif()

    option(HALLEY_HAS_DXC_X "Build with DXC (Xbox One) support" ${DXC_X_FOUND})
    option(HALLEY_HAS_DXC_XS "Build with DXC (Scarlett) support" ${DXC_XS_FOUND})
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
        if (HALLEY_HAS_DXC_X)
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:dxc_x> $<TARGET_FILE_DIR:${target}>
            )
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:scdll_x> $<TARGET_FILE_DIR:${target}>
            )
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:scdxil_x> $<TARGET_FILE_DIR:${target}>
            )
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:newbe_x> $<TARGET_FILE_DIR:${target}>
            )
        endif()
        if (HALLEY_HAS_DXC_XS)
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:dxc_xs> $<TARGET_FILE_DIR:${target}>
            )
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:xbsc_xs> $<TARGET_FILE_DIR:${target}>
            )
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:newbe_xs> $<TARGET_FILE_DIR:${target}>
            )
        endif()
    endif()
endmacro()
