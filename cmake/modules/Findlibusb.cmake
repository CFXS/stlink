# Findlibusb.cmake
# Find and install external libusb library

# Once done this will define
#
# LIBUSB_FOUND         libusb present on system
# LIBUSB_INCLUDE_DIR   the libusb include directory
# LIBUSB_LIBRARY       the libraries needed to use libusb
# LIBUSB_DEFINITIONS   compiler switches required for using libusb

include(FindPackageHandleStandardArgs)

if(APPLE) # macOS
    FIND_PATH(
        LIBUSB_INCLUDE_DIR NAMES libusb.h
        HINTS /usr /usr/local /opt
        PATH_SUFFIXES libusb-1.0
    )
    set(LIBUSB_NAME libusb-1.0.a)
    find_library(
        LIBUSB_LIBRARY NAMES ${LIBUSB_NAME}
        HINTS /usr /usr/local /opt
    )
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(libusb DEFAULT_MSG LIBUSB_LIBRARY LIBUSB_INCLUDE_DIR)
    mark_as_advanced(LIBUSB_INCLUDE_DIR LIBUSB_LIBRARY)

    if(NOT LIBUSB_FOUND)
        message(FATAL_ERROR "No libusb library found on your system! Install libusb-1.0 from Homebrew or MacPorts")
    endif()

elseif(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD") # FreeBSD; libusb is integrated into the system
    FIND_PATH(
        LIBUSB_INCLUDE_DIR NAMES libusb.h
        HINTS /usr/include
    )
    set(LIBUSB_NAME usb)
    find_library(
        LIBUSB_LIBRARY NAMES ${LIBUSB_NAME}
        HINTS /usr /usr/local /opt
    )
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(libusb DEFAULT_MSG LIBUSB_LIBRARY LIBUSB_INCLUDE_DIR)
    mark_as_advanced(LIBUSB_INCLUDE_DIR LIBUSB_LIBRARY)

    if(NOT LIBUSB_FOUND)
        message(FATAL_ERROR "Expected libusb library not found on your system! Verify your system integrity.")
    endif()

elseif(CMAKE_SYSTEM_NAME STREQUAL "OpenBSD") # OpenBSD; libusb-1.0 is available from ports
    FIND_PATH(
        LIBUSB_INCLUDE_DIR NAMES libusb.h
        HINTS /usr/local/include
        PATH_SUFFIXES libusb-1.0
    )
    set(LIBUSB_NAME usb-1.0)
    find_library(
        LIBUSB_LIBRARY NAMES ${LIBUSB_NAME}
        HINTS /usr/local
    )
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(libusb DEFAULT_MSG LIBUSB_LIBRARY LIBUSB_INCLUDE_DIR)
    mark_as_advanced(LIBUSB_INCLUDE_DIR LIBUSB_LIBRARY)

    if(NOT LIBUSB_FOUND)
        message(FATAL_ERROR "No libusb-1.0 library found on your system! Install libusb-1.0 from ports or packages.")
    endif()

elseif(WIN32 OR(EXISTS "/etc/debian_version" AND MINGW)) # Windows or MinGW-toolchain on Debian
    # MinGW/MSYS/MSVC: 64-bit or 32-bit?
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        message(STATUS "=== Building for Windows (x86-64) ===")
        set(ARCH 64)
    else()
        message(STATUS "=== Building for Windows (i686) ===")
        set(ARCH 32)
    endif()

    if (WIN32 AND NOT EXISTS "/etc/debian_version") # Skip this for Debian...
        # Find path to libusb library
        FIND_PATH(
            LIBUSB_INCLUDE_DIR NAMES libusb.h
            HINTS ${LIBUSB_PATH}/include
            PATH_SUFFIXES libusb-1.0
            NO_DEFAULT_PATH
            NO_CMAKE_FIND_ROOT_PATH
        )

        if(MINGW OR MSYS)
            set(LIBUSB_NAME usb-1.0)
            find_library(
                LIBUSB_LIBRARY NAMES ${LIBUSB_NAME}
                HINTS ${LIBUSB_PATH}/MinGW${ARCH}/static
                NO_DEFAULT_PATH
                NO_CMAKE_FIND_ROOT_PATH
            )

        else(MSVC)
            set(LIBUSB_NAME libusb-1.0.lib)
            find_library(
                LIBUSB_LIBRARY NAMES ${LIBUSB_NAME}
                HINTS ${LIBUSB_PATH}/VS2019/MS${ARCH}/Release/dll
                NO_DEFAULT_PATH
                NO_CMAKE_FIND_ROOT_PATH
            )
        endif()

        message(STATUS "Missing libusb library has been installed")
    endif()

    FIND_PACKAGE_HANDLE_STANDARD_ARGS(libusb DEFAULT_MSG LIBUSB_LIBRARY LIBUSB_INCLUDE_DIR)
    mark_as_advanced(LIBUSB_INCLUDE_DIR LIBUSB_LIBRARY)

else() # all other OS (unix-based)
    FIND_PATH(
        LIBUSB_INCLUDE_DIR NAMES libusb.h
        HINTS /usr /usr/local /opt
        PATH_SUFFIXES libusb-1.0
    )
    set(LIBUSB_NAME usb-1.0)
    find_library(
        LIBUSB_LIBRARY NAMES ${LIBUSB_NAME}
        HINTS /usr /usr/local /opt
    )
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(libusb DEFAULT_MSG LIBUSB_LIBRARY LIBUSB_INCLUDE_DIR)
    mark_as_advanced(LIBUSB_INCLUDE_DIR LIBUSB_LIBRARY)

    if(NOT LIBUSB_FOUND)
        message(FATAL_ERROR "libusb library not found on your system! Install libusb 1.0.x from your package repository.")
    endif()
endif()
