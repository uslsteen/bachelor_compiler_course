find_package(FLEX)
find_package(BISON)

file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/include/grammar/)

if (FLEX_FOUND) 
    flex_target(lex 
                lex.l 
                ${CMAKE_CURRENT_SOURCE_DIR}/lex.yy.cc)
else()
    message(STATUS "Flex package not found")
endif()

if (BISON_FOUND)
    bison_target(bison
        grammar.y
        ${CMAKE_CURRENT_SOURCE_DIR}/compiler.tab.cc
        COMPILE_FLAGS "--defines=${CMAKE_SOURCE_DIR}/include/grammar/compiler.tab.hh")
else()
    message(STATUS "Bisoc package not found")
endif()

if(BISON_FOUND)
    add_flex_bison_dependency(lex bison)
    add_library(grammar ${FLEX_lex_OUTPUTS} ${BISON_bison_OUTPUTS})
endif()