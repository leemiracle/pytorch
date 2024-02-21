# MKLDNN 是 Intel 专门为深度神经网络设计的数学核心库，用于加速深度学习推理过程。
set(MKLDNN_USE_NATIVE_ARCH ${USE_NATIVE_ARCH})

if(CPU_AARCH64)
  include(${CMAKE_CURRENT_LIST_DIR}/ComputeLibrary.cmake)
endif()

find_package(MKLDNN QUIET)

if(NOT TARGET caffe2::mkldnn)
  add_library(caffe2::mkldnn INTERFACE IMPORTED)
endif()

set_property(
  TARGET caffe2::mkldnn PROPERTY INTERFACE_INCLUDE_DIRECTORIES
  ${MKLDNN_INCLUDE_DIR})
set_property(
  TARGET caffe2::mkldnn PROPERTY INTERFACE_LINK_LIBRARIES
  ${MKLDNN_LIBRARIES})
