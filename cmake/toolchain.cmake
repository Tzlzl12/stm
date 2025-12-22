set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

# auto search path
if(DEFINED ENV{ARM_TOOLCHAIN_DIR})
    set(TOOLCHAIN_DIR $ENV{ARM_TOOLCHAIN_DIR})
elseif(WIN32)
  # for Windows
    set(TOOLCHAIN_DIR "C:/ST/STM32CubeCLT/GNU-tools-for-STM32/bin")
elseif(APPLE)
  # for macOS
    set(TOOLCHAIN_DIR "/opt/homebrew/bin")
else()
  # for Liunx
    set(TOOLCHAIN_DIR "/usr/bin")
endif()

# set for compiler
find_program(CMAKE_C_COMPILER NAMES arm-none-eabi-gcc HINTS ${TOOLCHAIN_DIR})
find_program(CMAKE_CXX_COMPILER NAMES arm-none-eabi-g++ HINTS ${TOOLCHAIN_DIR})
find_program(CMAKE_ASM_COMPILER NAMES arm-none-eabi-gcc HINTS ${TOOLCHAIN_DIR})

# set for toolchain
find_program(CMAKE_AR NAMES
arm-none-eabi-gcc-ar arm-none-eabi-ar
HINTS ${TOOLCHAIN_DIR})
find_program(CMAKE_OBJCOPY NAMES arm-none-eabi-objcopy HINTS ${TOOLCHAIN_DIR})
find_program(CMAKE_OBJDUMP NAMES arm-none-eabi-objdump HINTS ${TOOLCHAIN_DIR})
find_program(CMAKE_SIZE NAMES arm-none-eabi-size HINTS ${TOOLCHAIN_DIR})
find_program(CMAKE_NM NAMES arm-none-eabi-nm HINTS ${TOOLCHAIN_DIR})
find_program(CMAKE_STRIP NAMES arm-none-eabi-strip HINTS ${TOOLCHAIN_DIR})
find_program(CMAKE_RANLIB NAMES
arm-none-eabi-gcc-ranlib arm-none-eabi-ranlib
HINTS ${TOOLCHAIN_DIR})

# test for toolchain
foreach(tool IN ITEMS C_COMPILER CXX_COMPILER
ASM_COMPILER AR OBJCOPY OBJDUMP SIZE)
    if(NOT CMAKE_${tool})
        message(FATAL_ERROR "ARM toolchain not found: ${tool}")
    endif()
endforeach()

# set for compiler id
set(CMAKE_C_COMPILER_ID GNU)
set(CMAKE_CXX_COMPILER_ID GNU)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_ASM ".elf")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# ===== C/C++ 通用编译选项 (基础) =====
set(COMMON_FLAGS
    -fdata-sections
    -ffunction-sections
    -fstack-usage
    -Wall
    -Wextra
)

# ===== C 编译选项 =====
set(CMAKE_C_FLAGS_INIT
    "${COMMON_FLAGS}"
    CACHE STRING "" FORCE
)
list(APPEND CMAKE_C_FLAGS_INIT
    -Werror=implicit-function-declaration
    -Werror=return-type
)
string(REPLACE ";" " " CMAKE_C_FLAGS_INIT "${CMAKE_C_FLAGS_INIT}")

# ===== C++ 编译选项 =====
set(CMAKE_CXX_FLAGS_INIT
    "${COMMON_FLAGS}"
    CACHE STRING "" FORCE
)
list(APPEND CMAKE_CXX_FLAGS_INIT
    -Wnon-virtual-dtor
    -Woverloaded-virtual
    -fno-exceptions
    -fno-rtti
    -fno-use-cxa-atexit
)
string(REPLACE ";" " " CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT}")

# ===== ASM 编译选项 =====
set(CMAKE_ASM_FLAGS_INIT
    "-x assembler-with-cpp"
    CACHE STRING "" FORCE
)

# ===== Debug 构建选项 =====
set(CMAKE_C_FLAGS_DEBUG_INIT "-Og -g3 -gdwarf-2" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG_INIT "-Og -g3 -gdwarf-2" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS_DEBUG_INIT "-g3 -gdwarf-2" CACHE STRING "" FORCE)

# ===== Release 构建选项 =====
set(CMAKE_C_FLAGS_RELEASE_INIT "-O2 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE_INIT "-O2 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS_RELEASE_INIT "" CACHE STRING "" FORCE)

# ===== MinSizeRel 构建选项 =====
set(CMAKE_C_FLAGS_MINSIZEREL_INIT "-Os -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT "-Os -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS_MINSIZEREL_INIT "" CACHE STRING "" FORCE)

# ===== RelWithDebInfo 构建选项 =====
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT
"-O2 -g -gdwarf-2" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT
"-O2 -g -gdwarf-2" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT
"-g -gdwarf-2" CACHE STRING "" FORCE)

# ===== 链接器选项 (基础) =====
set(CMAKE_EXE_LINKER_FLAGS_INIT
    "-Wl,--start-group -lc -lm -lstdc++ -Wl,--end-group"
    CACHE STRING "" FORCE
)

# ===== Debug 链接选项 =====
set(CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT
    "-u_printf_float -u_scanf_float"
    CACHE STRING "" FORCE
)
if(ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT IPO_SUPPORTED OUTPUT IPO_ERROR)
    if(IPO_SUPPORTED)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    else()
        message(WARNING "IPO is not supported: ${IPO_ERROR}")
    endif()
endif()
