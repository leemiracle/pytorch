# MKL（Math Kernel Library）是英特尔开发的数学核心库，提供了针对英特尔处理器优化的高性能数学函数。
find_package(MKL QUIET)

if(TARGET caffe2::mkl)
  return()
endif()

add_library(caffe2::mkl INTERFACE IMPORTED)
target_include_directories(caffe2::mkl INTERFACE ${MKL_INCLUDE_DIR})
target_link_libraries(caffe2::mkl INTERFACE ${MKL_LIBRARIES})
foreach(MKL_LIB IN LISTS MKL_LIBRARIES)
  if(EXISTS "${MKL_LIB}")
    get_filename_component(MKL_LINK_DIR "${MKL_LIB}" DIRECTORY)
    if(IS_DIRECTORY "${MKL_LINK_DIR}")
      target_link_directories(caffe2::mkl INTERFACE "${MKL_LINK_DIR}")
    endif()
  endif()
endforeach()

# TODO: This is a hack, it will not pick up architecture dependent
# MKL libraries correctly; see https://github.com/pytorch/pytorch/issues/73008
set_property(
  TARGET caffe2::mkl PROPERTY INTERFACE_LINK_DIRECTORIES
  ${MKL_ROOT}/lib ${MKL_ROOT}/lib/intel64 ${MKL_ROOT}/lib/intel64_win ${MKL_ROOT}/lib/win-x64)
