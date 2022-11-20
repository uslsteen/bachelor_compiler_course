set(TARGETS parser)
#
foreach(TARGET ${TARGETS})
    add_library(${TARGET} ${TARGET}.cc)
endforeach()