cmake_minimum_required(VERSION 3.15)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "default build type")
endif()

project(LunarLander1969
  LANGUAGES Fortran)

include(CTest)

add_executable(lunar-lander lunar.f90)

if(BUILD_TESTING)
find_package(Python COMPONENTS Interpreter)
if(Python_FOUND)
  add_test(NAME basic
    COMMAND Python::Interpreter ${CMAKE_CURRENT_SOURCE_DIR}/test_stdin.py $<TARGET_FILE:lunar-lander> ${CMAKE_CURRENT_SOURCE_DIR}/good.asc --args='-f\ 16000')
endif(Python_FOUND)
endif(BUILD_TESTING)
