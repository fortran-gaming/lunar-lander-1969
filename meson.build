project('Lunar Lander 1969', 'fortran',
  default_options : ['default_library=static', 'buildtype=release'])

lunar = executable('lunar', 'lunar.f90',
  install: true)

python = find_program('python')

test('Lunar basic', python,
  args: ['test_stdin.py', lunar, 'good.asc', '--args="-f 16000"'],
  workdir : meson.source_root())
