find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/include/grammar/)
#
if (FLEX_FOUND)
    flex_target(lex
        ${CMAKE_CURRENT_SOURCE_DIR}/lex.l
        ${CMAKE_CURRENT_SOURCE_DIR}/lex.yy.cc)
else()
    message(STATUS "Flex package not found")
endif()
#
if (BISON_FOUND)
#
    bison_target(bison
        ${CMAKE_CURRENT_SOURCE_DIR}/grammar.y
        ${CMAKE_CURRENT_SOURCE_DIR}/compiler.tab.cc
    #    DEFINES_FILE ${CMAKE_SOURCE_DIR}/include/grammar/compiler.tab.hh
    #    DEFINES_FILE ${CMAKE_SOURCE_DIR}/include/grammar/location.hh
    #    DEFINES_FILE ${CMAKE_SOURCE_DIR}/include/grammar/position.hh
    #    DEFINES_FILE ${CMAKE_SOURCE_DIR}/include/grammar/stack.hh
    )
#
else()
    message(STATUS "Bison package not found")
endif()
#
if(BISON_FOUND)
    add_flex_bison_dependency(lex bison)
    add_library(grammar ${FLEX_lex_OUTPUTS} ${BISON_bison_OUTPUTS})
endif()