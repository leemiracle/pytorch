# 在 PyTorch 中，Vulkan 的支持意味着你可以利用 Vulkan API 来加速深度学习模型的训练和推理。通过 Vulkan 的并行计算能力，
#    你可以在支持 Vulkan 的 GPU 上更有效地执行张量操作和神经网络计算，从而提高模型的性能和效率。
# Vulkan 是指 Vulkan 图形和计算 API。Vulkan 是一种由 Khronos Group 维护的低级图形 API，
#     旨在提供更高性能和更低的驱动程序开销。它允许开发人员直接控制 GPU，从而实现更高效的图形渲染和计算。


# Shaders processing
if(NOT USE_VULKAN)
  return()
endif()

set(VULKAN_GEN_OUTPUT_PATH "${CMAKE_BINARY_DIR}/vulkan/ATen/native/vulkan")
set(VULKAN_GEN_ARG_ENV "")

if(USE_VULKAN_RELAXED_PRECISION)
  list(APPEND VULKAN_GEN_ARG_ENV "PRECISION=mediump")
endif()
if(USE_VULKAN_FP16_INFERENCE)
  list(APPEND VULKAN_GEN_ARG_ENV "FLOAT_IMAGE_FORMAT=rgba16f")
else()
  list(APPEND VULKAN_GEN_ARG_ENV "FLOAT_IMAGE_FORMAT=rgba32f")
endif()

# Precompiling shaders
if(ANDROID)
  if(NOT ANDROID_NDK)
    message(FATAL_ERROR "ANDROID_NDK not set")
  endif()

  set(GLSLC_PATH "${ANDROID_NDK}/shader-tools/${ANDROID_NDK_HOST_SYSTEM_NAME}/glslc")
else()
  find_program(
    GLSLC_PATH glslc
    PATHS
    ENV VULKAN_SDK
    PATHS "$ENV{VULKAN_SDK}/${CMAKE_HOST_SYSTEM_PROCESSOR}/bin"
    PATHS "$ENV{VULKAN_SDK}/bin"
  )

  if(NOT GLSLC_PATH)
    message(FATAL_ERROR "USE_VULKAN glslc not found")
  endif(NOT GLSLC_PATH)
endif()

set(PYTHONPATH "$ENV{PYTHONPATH}")
set(NEW_PYTHONPATH ${PYTHONPATH})
list(APPEND NEW_PYTHONPATH "${CMAKE_CURRENT_LIST_DIR}/..")
set(ENV{PYTHONPATH} ${NEW_PYTHONPATH})
execute_process(
  COMMAND
  "${PYTHON_EXECUTABLE}"
  ${CMAKE_CURRENT_LIST_DIR}/../tools/gen_vulkan_spv.py
  --glsl-path ${CMAKE_CURRENT_LIST_DIR}/../aten/src/ATen/native/vulkan/glsl
  --output-path ${VULKAN_GEN_OUTPUT_PATH}
  --glslc-path=${GLSLC_PATH}
  --tmp-dir-path=${CMAKE_BINARY_DIR}/vulkan/spv
  --env ${VULKAN_GEN_ARG_ENV}
  RESULT_VARIABLE error_code)
set(ENV{PYTHONPATH} ${PYTHONPATH})

  if(error_code)
    message(FATAL_ERROR "Failed to gen spv.h and spv.cpp with precompiled shaders for Vulkan backend")
  endif()

set(vulkan_generated_cpp ${VULKAN_GEN_OUTPUT_PATH}/spv.cpp)
