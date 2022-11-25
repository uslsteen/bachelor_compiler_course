set(DIRS glang)
set(LANG_LIB ${DIRS})

set(LLVM_LIBRARIES LLVM-14)

#
foreach(DIR ${DIRS})
    add_subdirectory(${DIR})
    message("Included subdirectory: ${DIR}")
endforeach()

foreach(LANG ${LANG_LIB})
    target_include_directories(${LANG} SYSTEM PRIVATE ${CMAKE_SOURCE_DIR}/thirdparty/CLI11/include)
    target_include_directories(${LANG} PRIVATE ${CMAKE_SOURCE_DIR}/include)
    target_link_libraries(${LANG} PRIVATE ${LLVM_LIBRARIES} CLI11::CLI11)

    set_target_properties(${LANG} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/")
endforeach()

set(LANG_LIB ${LANG_LIB} PARENT_SCOPE)