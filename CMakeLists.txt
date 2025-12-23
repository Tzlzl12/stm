cmake_minimum_required(VERSION 3.22)
include("cmake/options.cmake")

include("cmake/toolchain.cmake")

project(STM32 VERSION 0.0.1 LANGUAGES ASM C CXX)

include("cmake/mcu.cmake")

# Enable CMake support for ASM and C languages
enable_language(C ASM CXX)

# Create an executable object type
add_executable(${PROJECT_NAME})

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/dev)
  add_subdirectory(dev)
  target_link_libraries(${PROJECT_NAME} dev)
endif()

# Add sources to executable
target_sources(${PROJECT_NAME} PRIVATE
    # Add user sourcese
    ${CMAKE_SOURCE_DIR}/main.c
)

