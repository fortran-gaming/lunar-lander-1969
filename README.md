# Lunar Lander 1969:  BASIC and Fortran

![Actions Status](https://github.com/fortran-gaming/lunar-lander-1969/workflows/ci_meson/badge.svg)
![Actions Status](https://github.com/fortran-gaming/lunar-lander-1969/workflows/ci_cmake/badge.svg)

* [Jim Storer](http://www.cs.brandeis.edu/~storer/LunarLander/LunarLander.html), fall 1969: PDP-8 FOCAL
* David H. Ahl, 1973: [BASIC](http://www.cs.brandeis.edu/~storer/LunarLander/LunarLander/Articles/Rocket-101BasicComputerGames.pdf)

This game is presented in:

* BASIC `lunar.bas` adapted from the 1969 source code, compatible with modern ANSI BASIC interpreters.
* Fortran `lunar.f90` by Michael Hirsch is also given.

## Build
Any Fortran 2008 compliant compiler should work.

```sh
ctest -S setup.cmake -VV
```

## Usage

The program defaults to stdin from user.

```sh
./build/lunar-lander
```

Options:

* `-d` allows file redirection for testing and optimization
* `-f` specifies initial fuel weight

To mimic the 1969 results

```sh
lunar-lander -f 16000 -d < fail.asc

lunar-lander -f 16000 -d < ok.asc
```

The final output line is formatted for automatic parsing.

### BASIC

For reference the 1973 BASIC program from David Ahl may be run with many ANSI BASIC interpreters like:

```sh
bwbasic lunar.bas
```

## Notes

* 1969 fail [output](http://www.cs.brandeis.edu/~storer/LunarLander/LunarLander/LunarLanderSampleOutputPage1.jpg)
* 1969 success [output](http://www.cs.brandeis.edu/~storer/LunarLander/LunarLander/LunarLanderSampleOutputPage2.jpg)
