# PyTorch Metal 是 PyTorch 在 macOS 和 iOS 平台上使用 Metal 图形 API 的支持。
# Metal 是苹果公司提供的用于编写高性能图形和计算代码的低级图形 API，它可以在 macOS 和 iOS 设备上直接访问 GPU，并提供了与 OpenGL 和 OpenCL 相比更低的开销和更高的性能

if(NOT APPLE)
    return()
endif()

if(NOT USE_PYTORCH_METAL)
    return()
endif()

if(IOS OR INTERN_BUILD_MOBILE)
    return()
endif()

set(OSX_PLATFORM "MacOSX.platform")
exec_program(/usr/bin/xcode-select ARGS -print-path OUTPUT_VARIABLE CMAKE_XCODE_DEVELOPER_DIR)
set(XCODE_POST_43_ROOT "${CMAKE_XCODE_DEVELOPER_DIR}/Platforms/${OSX_PLATFORM}/Developer")
set(XCODE_PRE_43_ROOT "/Developer/Platforms/${OSX_PLATFORM}/Developer")
if(NOT DEFINED CMAKE_OSX_DEVELOPER_ROOT)
    if(EXISTS ${XCODE_POST_43_ROOT})
        set(CMAKE_OSX_DEVELOPER_ROOT ${XCODE_POST_43_ROOT})
    elseif(EXISTS ${XCODE_PRE_43_ROOT})
        set(CMAKE_OSX_DEVELOPER_ROOT ${XCODE_PRE_43_ROOT})
    elseif(EXISTS ${CMAKE_XCODE_DEVELOPER_DIR} AND ${CMAKE_XCODE_DEVELOPER_DIR} STREQUAL "/Library/Developer/CommandLineTools")
            set(CMAKE_OSX_DEVELOPER_ROOT ${CMAKE_XCODE_DEVELOPER_DIR})
    endif()
endif(NOT DEFINED CMAKE_OSX_DEVELOPER_ROOT)
set(CMAKE_OSX_DEVELOPER_ROOT ${CMAKE_OSX_DEVELOPER_ROOT} CACHE PATH "Location of OSX SDKs root directory")

if(NOT DEFINED CMAKE_OSX_SDK_ROOT)
    file(GLOB _CMAKE_OSX_SDKS "${CMAKE_OSX_DEVELOPER_ROOT}/SDKs/*")
    if(_CMAKE_OSX_SDKS)
        list(SORT _CMAKE_OSX_SDKS)
        list(REVERSE _CMAKE_OSX_SDKS)
        list(GET _CMAKE_OSX_SDKS 0 CMAKE_OSX_SDK_ROOT)
        message(STATUS "_CMAKE_OSX_SDKS: ${_CMAKE_OSX_SDKS}")
    else(_CMAKE_OSX_SDKS)
        message(FATAL_ERROR "No OSX SDK's found in default search path ${CMAKE_OSX_DEVELOPER_ROOT}.")
    endif(_CMAKE_OSX_SDKS)
    message(STATUS "Toolchain using default OSX SDK: ${CMAKE_OSX_SDK_ROOT}")
endif(NOT DEFINED CMAKE_OSX_SDK_ROOT)
set(CMAKE_OSX_SDK_ROOT ${CMAKE_OSX_SDK_ROOT} CACHE PATH "Location of the selected OSX SDK")
set(CMAKE_FRAMEWORK_PATH
    ${CMAKE_OSX_SDK_ROOT}/System/Library/Frameworks
    ${CMAKE_OSX_SDK_ROOT}/System/Library/PrivateFrameworks
    ${CMAKE_OSX_SDK_ROOT}/Developer/Library/Frameworks
)
message(STATUS "CMAKE_FRAMEWORK_PATH: ${CMAKE_FRAMEWORK_PATH}")
set(CMAKE_FIND_FRAMEWORK FIRST)
