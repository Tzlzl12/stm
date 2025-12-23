# 清除之前可能设置的所有标志
unset(CMAKE_C_FLAGS CACHE)
unset(CMAKE_EXE_LINKER_FLAGS CACHE)

# 基础架构选项
set(MCU_ARCH_FLAGS "-mcpu=${MCU_CPU} -mthumb")

# FPU 支持
if(ENABLE_FPU)
  set(MCU_ARCH_FLAGS "${MCU_ARCH_FLAGS} -mfpu=fpv4-sp-d16 -mfloat-abi=hard")
else()
  set(MCU_ARCH_FLAGS "${MCU_ARCH_FLAGS} -mfloat-abi=soft")
endif()

# 设置编译标志 - 只设置一次
set(CMAKE_C_FLAGS
    "${MCU_ARCH_FLAGS} 
    -Wall -Wextra -Wpedantic 
    -fdata-sections -ffunction-sections 
    -Og -g3"
    CACHE STRING "C Compiler Flags" FORCE
)

set(CMAKE_ASM_FLAGS 
    "${CMAKE_C_FLAGS} -x assembler-with-cpp -MMD -MP"
    CACHE STRING "ASM Compiler Flags" FORCE
)

set(CMAKE_CXX_FLAGS
    "${CMAKE_C_FLAGS} -fno-rtti -fno-exceptions -fno-threadsafe-statics"
    CACHE STRING "C++ Compiler Flags" FORCE
)

# 链接标志 - 只设置一次
set(LINK_FLAGS "${MCU_ARCH_FLAGS}")

if(ENABLE_NANO_LIBS)
    set(LINK_FLAGS "${LINK_FLAGS} -specs=nano.specs")
endif()

if(ENABLE_NOSYS)
    set(LINK_FLAGS "${LINK_FLAGS} -specs=nosys.specs")
endif()

# 添加链接器脚本和其他选项
set(LINK_FLAGS "
  ${LINK_FLAGS} 
  -T ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_SCRIPT} 
  -Wl,-Map=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.map 
  -Wl,--gc-sections 
  -Wl,--print-memory-usage 
  -Wl,--start-group -lc -lm 
  -Wl,--end-group"
)

# 设置链接标志 - 只在这里设置
set(CMAKE_EXE_LINKER_FLAGS
    "${LINK_FLAGS}"
    CACHE STRING "Linker Flags" FORCE
)

# 移除 C++ 特定链接标志（如果有的话）
# set(CMAKE_CXX_LINK_FLAGS ...)
