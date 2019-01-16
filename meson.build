project('Lunar Lander 1969', 'fortran')

lunar = executable('lunar', 'lunar.f90')
test('Lunar basic', lunar, args : ['-d','-f','16000'])
# ninja test < ../good.asc
