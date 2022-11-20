set(LANG lang)

add_executable(${LANG} main.cc)
target_link_libraries(${LANG} PRIVATE CLI11::CLI11)
target_include_directories(${LANG} SYSTEM PRIVATE ${CMAKE_SOURCE_DIR}/3rd_party/CLI11/include)