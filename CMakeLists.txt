cmake_minimum_required(VERSION 3.15)

project(LunarLander1969
  LANGUAGES Fortran)

enable_testing()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

add_executable(lunar-lander lunar.f90)

add_test(NAME basic
COMMAND ${CMAKE_COMMAND}
  -Dexe:FILEPATH=$<TARGET_FILE:lunar-lander>
  -P ${CMAKE_CURRENT_SOURCE_DIR}/tests/test_stdin.cmake
)
set_property(TEST basic PROPERTY PASS_REGULAR_EXPRESSION "GOOD LANDING")
