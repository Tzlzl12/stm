# set for standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_BUILD_DATABASE ON)
set(CMAKE_COLOR_DIAGNOSTICS ON)
# # linker script path
set(STM_LINK_SCRIPT "stm32f401rct6.ld" CACHE STRING "Linker script path")

# MCU configuration
set(MCU_FAMILY "STM32F4" CACHE STRING "STM32 Family")
set(MCU_SERIES "STM32F4xx" CACHE STRING "STM32 Series")
set(MCU_MODEL "STM32F401xx" CACHE STRING "STM32 Model")
set(MCU_CPU "cortex-m4" CACHE STRING "CPU Core")

# build flags
option(ENABLE_ASSERT "Enable assertions" OFF)
option(ENABLE_NANO_LIBS "Use nano libraries" ON)
option(ENABLE_NOSYS "Use nosys spec" ON)
option(ENABLE_LTO "Enable link-time optimization" OFF)
option(ENABLE_IPO "Enable interprocedural optimization" OFF)
option(ENABLE_DEBUG "Enable debug symbols" ON)
option(ENABLE_OPTIMIZE "Enable optimization" ON)
option(ENABLE_FPU "Enable FPU support" ON)

# flags for middleware
option(ENABLE_FREERTOS "Enable FreeRTOS" OFF)
option(ENABLE_LWIP "Enable LWIP" OFF)
option(ENABLE_FATFS "Enable FATFS" OFF)
option(ENABLE_USB "Enable USB" OFF)

# config for openocd
set(OPENOCD_SCRIPT "interface/stlink.cfg"
CACHE STRING "OpenOCD interface script")
set(OPENOCD_TARGET "target/stm32f4x.cfg"
CACHE STRING "OpenOCD target script")

# OpenOCD 自定义配置文件 (可选)
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/cmake/openocd.cfg)
  set(OPENOCD_CFG_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/openocd.cfg"
    CACHE STRING "Custom OpenOCD configuration file")
endif()

# compiler extra
option(WARNINGS_AS_ERRORS "Treat warnings as errors" OFF)
option(ENABLE_ALL_WARNINGS "Enable all warnings" ON)
option(ENABLE_EXTRA_WARNINGS "Enable extra warnings" ON)

# set for debug
set(DEBUG_LEVEL "3" CACHE STRING "Debug level (0-3)")
set_property(CACHE DEBUG_LEVEL PROPERTY STRINGS "0" "1" "2" "3")

# optimization level
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Debug" CACHE STRING
    "Build type (Debug, Release, MinSizeRel, RelWithDebInfo)"
    FORCE)
endif()
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
  "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
