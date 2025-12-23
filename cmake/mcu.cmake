set(MCU_FLAGS "-mcpu=${MCU_CPU} -mthumb")

if(ENABLE_FPU)
    set(MCU_FLAGS "${MCU_FLAGS} -mfpu=fpv4-sp-d16 -mfloat-abi=hard")
else()
    set(MCU_FLAGS "${MCU_FLAGS} -mfloat-abi=soft")
endif()
# 根据构建类型设置优化选项
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(OPTIMIZATION_FLAGS "-Og -g3")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(OPTIMIZATION_FLAGS "-Os")
elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    set(OPTIMIZATION_FLAGS "-Os")
elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    set(OPTIMIZATION_FLAGS "-O2 -g3")
else()
    set(OPTIMIZATION_FLAGS "-Og -g3")  # 默认
endif()
# C 标志
set(CMAKE_C_FLAGS
  "${MCU_FLAGS} -Wall -Wextra -Wpedantic -fdata-sections -ffunction-sections ${OPTIMIZATION_FLAGS}"
  CACHE STRING "C flags" FORCE
)

# ASM 标志  
set(CMAKE_ASM_FLAGS
  "${MCU_FLAGS} -Wall -Wextra -Wpedantic -fdata-sections -ffunction-sections -Og -g3 -x assembler-with-cpp"
  CACHE STRING "ASM flags" FORCE
)
set(CMAKE_CXX_FLAGS
    "${CMAKE_C_FLAGS} -fno-rtti -fno-exceptions -fno-threadsafe-statics"
    CACHE STRING "C++ Compiler Flags" FORCE
)
# 链接标志
set(LINKER_FLAGS "${MCU_FLAGS}")

if(ENABLE_NANO_LIBS)
    set(LINKER_FLAGS "${LINKER_FLAGS} -specs=nano.specs")
endif()

if(ENABLE_NOSYS)
    set(LINKER_FLAGS "${LINKER_FLAGS} -specs=nosys.specs")
endif()

set(LINKER_FLAGS "${LINKER_FLAGS} -T ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_SCRIPT} -Wl,-Map=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.map -Wl,--gc-sections -Wl,--print-memory-usage -Wl,--start-group -lc -lm -Wl,--end-group")

set(CMAKE_EXE_LINKER_FLAGS
    "${LINKER_FLAGS}"
    CACHE STRING "Linker flags" FORCE
)

set(CMAKE_CXX_LINK_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} -Wl,--start-group -lstdc++ -lsupc++ -Wl,--end-group"
    CACHE STRING "C++ Linker Flags" FORCE
)
