set(LANG lang)

set(LLVM_LIBRARIES LLVM-14)

add_executable(${LANG} main.cc __std_lib/lib.cc)
target_include_directories(${LANG} PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(${LANG} PRIVATE ${LLVM_LIBRARIES})
#target_link_libraries(${LANG} PRIVATE CLI11::CLI11)
#target_include_directories(${LANG} SYSTEM PRIVATE ${CMAKE_SOURCE_DIR}/3rd_party/CLI11/include)