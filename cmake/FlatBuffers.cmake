# FlatBuffers 的核心思想是定义一个数据结构的模式（schema），然后使用这个模式生成代码来序列化和反序列化数据。这个模式描述了数据的结构和布局，包括字段的类型、名称和相对位置等信息。
#      通过这种方式，FlatBuffers 可以在不需要运行时反射的情况下，快速地序列化和反序列化数据，从而提高性能并减少内存占用。
#     高效地序列化和反序列化数据
set(FlatBuffers_Include ${PROJECT_SOURCE_DIR}/third_party/flatbuffers/include)
file(GLOB FlatBuffers_Library_SRCS
  ${FlatBuffers_Include}/flatbuffers/*.h
)
add_library(flatbuffers INTERFACE)
target_sources(
  flatbuffers
  INTERFACE ${FlatBuffers_Library_SRCS}
)
target_include_directories(flatbuffers INTERFACE ${FlatBuffers_Include})
