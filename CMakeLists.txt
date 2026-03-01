# From https://github.com/LifeWithDavid/RaspberryPiPico-BareMetalAdventures/blob/main/Chapter%2002/CMakeLists.txt

cmake_minimum_required(VERSION 3.19.8)

# Inlcude the pi pico C/C++ SDK
include(pico_sdk_import.cmake)

project(bare_metal_blink C CXX ASM
)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(PICO_EXAMPLES_PATH ${PROJECT_SOURCE_DIR})

# Initialize the pi pico C/C++ SDK
pico_sdk_init()

add_executable(${PROJECT_NAME}

	helper.c
	blink.s

)

# Link to pico standard library
target_link_libraries(${PROJECT_NAME}

	pico_stdlib

)

# Create map/bin/hex file
pico_add_extra_outputs(${PROJECT_NAME})

# Enable usb output, disable uart output
pico_enable_stdio_usb(${PROJECT_NAME} 1)
pico_enable_stdio_uart(${PROJECT_NAME} 0)
