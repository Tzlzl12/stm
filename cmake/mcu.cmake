# ===== MCU 宏定义 =====
set(MCU_DEFINES
  ${MCU_MODEL}
  USE_HAL_DRIVER
)

# ===== 基础架构选项 =====
set(MCU_ARCH_FLAGS
  -mcpu=${MCU_CPU}
  -mthumb
)

# ===== FPU 配置 =====
if(ENABLE_FPU)
  list(APPEND MCU_ARCH_FLAGS
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
  )
  list(APPEND MCU_DEFINES
    __FPU_PRESENT=1
    ARM_MATH_CM4
  )
else()
  list(APPEND MCU_ARCH_FLAGS
    -mfloat-abi=soft
  )
endif()

# ===== 导出供 target 使用的编译选项 =====
# 所有架构相关选项 + 可选 LTO
set(MCU_COMPILE_OPTIONS
  ${MCU_ARCH_FLAGS}
  $<$<BOOL:${ENABLE_LTO}>:-flto>
)

# ===== 导出供 target 使用的链接选项 =====
set(MCU_LINK_OPTIONS
  ${MCU_ARCH_FLAGS}
  $<$<BOOL:${ENABLE_LTO}>:-flto>
  -Wl,--gc-sections
  -Wl,--print-memory-usage
  -Wl,--cref
  -Wl,--no-warn-mismatch
  -static
  $<$<BOOL:${ENABLE_NANO_LIBS}>:-specs=nano.specs>
  $<$<BOOL:${ENABLE_NOSYS}>:-specs=nosys.specs>
)

# ===== 导出宏定义和链接脚本 =====
set(MCU_DEFINES ${MCU_DEFINES})
set(LINKER_SCRIPT ${STM_LINK_SCRIPT})
