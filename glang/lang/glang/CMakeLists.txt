add_executable(glang lib.cc main.cc)
target_link_libraries(glang PRIVATE sfml-window sfml-system sfml-graphics)
