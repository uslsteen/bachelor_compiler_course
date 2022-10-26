cmake_minimum_required(VERSION 3.16)
project(ir_gen)
set(CMAKE_CXX_STANDARD 17)

find_package(LLVM 14 REQUIRED CONFIG)
set(CMAKE_VERBOSE_MAKEFILE OFF)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

find_package(SFML 2.5 COMPONENTS system window graphics REQUIRED)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

set(IR_GEN_SRC transltr.cc main.cc)
set(GRAPH_SRC ../game_of_life/graph_wrapp/graph_wrapp.cc)

add_executable(ir_gen ${IR_GEN_SRC} ${GRAPH_SRC})
set(LLVM_LIBRARIES LLVM-14)

# Link against LLVM libraries
target_link_libraries(ir_gen ${LLVM_LIBRARIES} sfml-window sfml-system sfml-graphics)