#
# Defines SDL3::SDL3 (and SDL3::XCurl) import libraries for Windows desktop,
# GDK desktop, Xbox One and Xbox Scarlett.
#
# The add_sdl3_runtime_dependencies() macro is used in HalleyProject.cmake to
# copy runtime DLLs to the binaries output directory.
#
add_library(SDL3::SDL3 SHARED IMPORTED GLOBAL)
target_include_directories(
    SDL3::SDL3
    INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/include
)

if (_GAMING_DESKTOP)
    set_property(
        TARGET SDL3::SDL3
        PROPERTY IMPORTED_IMPLIB
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Desktop.x64/Release/SDL3.lib
    )
    set_property(
        TARGET SDL3::SDL3
        PROPERTY IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Desktop.x64/Release/SDL3.dll
    )
    add_library(SDL3::XCurl UNKNOWN IMPORTED GLOBAL)
    set_property(
            TARGET SDL3::XCurl
            PROPERTY IMPORTED_LOCATION
            ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Desktop.x64/Release/XCurl.dll
    )
elseif (_GAMING_XBOX_XBOXONE)
    set_property(
        TARGET SDL3::SDL3
        PROPERTY IMPORTED_IMPLIB
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Xbox.XboxOne.x64/Release/SDL3.lib
    )
    set_property(
        TARGET SDL3::SDL3
        PROPERTY IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Xbox.XboxOne.x64/Release/SDL3.dll
    )
    add_library(SDL3::XCurl UNKNOWN IMPORTED GLOBAL)
    set_property(
            TARGET SDL3::XCurl
            PROPERTY IMPORTED_LOCATION
            ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Xbox.XboxOne.x64/Release/XCurl.dll
    )
elseif (_GAMING_XBOX_SCARLETT)
    set_property(
        TARGET SDL3::SDL3
        PROPERTY IMPORTED_IMPLIB
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Xbox.Scarlett.x64/Release/SDL3.lib
    )
    set_property(
        TARGET SDL3::SDL3
        PROPERTY IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Xbox.Scarlett.x64/Release/SDL3.dll
    )
    add_library(SDL3::XCurl UNKNOWN IMPORTED GLOBAL)
    set_property(
            TARGET SDL3::XCurl
            PROPERTY IMPORTED_LOCATION
            ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/Gaming.Xbox.Scarlett.x64/Release/XCurl.dll
    )
elseif (WIN32)
    set_property(
        TARGET SDL3::SDL3
        PROPERTY IMPORTED_IMPLIB
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/lib/SDL3.lib
    )
    set_property(
        TARGET SDL3::SDL3
        PROPERTY IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/win64/SDL3/bin/SDL3.dll
    )
endif()

macro(add_sdl3_runtime_dependencies target)
    if (_GAMING_DESKTOP OR _GAMING_XBOX OR WIN32)
        add_custom_command(
            TARGET
            ${target}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:SDL3::SDL3> $<TARGET_FILE_DIR:${target}>
        )
        if (NOT WIN32)
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:SDL3::XCurl> $<TARGET_FILE_DIR:${target}>
            )
        endif()
    endif()
endmacro()
