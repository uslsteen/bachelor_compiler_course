set(TARGETS driver)

foreach(TARGET ${TARGETS})
    add_library(${TARGET} ${TARGET}.cc)
endforeach()