#set(TARGETS node builder)

#foreach(TARGET ${TARGETS})
add_library(compiler node.cc builder.cc)
#endforeach()