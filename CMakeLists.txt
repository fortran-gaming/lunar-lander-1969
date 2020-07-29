cmake_minimum_required(VERSION 3.12)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "default build type")
endif()
project(LunarLander1969
  LANGUAGES Fortran)
enable_testing()

add_executable(lunar-lander lunar.f90)

find_package(Python3 COMPONENTS Interpreter)

if(Python3_FOUND)
add_test(NAME basic COMMAND ${Python3_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/test_stdin.py $<TARGET_FILE:lunar-lander> ${CMAKE_CURRENT_SOURCE_DIR}/good.asc --args='-f\ 16000')
endif()
