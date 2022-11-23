# SUBDIRS(DIRS ${CMAKE_CURRENT_SOURCE_DIR})
set(DIRS grammar parser driver compiler)

set(LANG_SRC ${DIRS})

foreach(TARGET ${DIRS})
    print(TARGET)
    add_subdirectory(${TARGET})
endforeach()

set(LANG_SRC ${LANG_SRC} PARENT_SCOPE)
