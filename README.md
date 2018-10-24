[![Build Status](https://travis-ci.com/fortran-gaming/lunar-lander-1969.svg?branch=master)](https://travis-ci.com/fortran-gaming/lunar-lander-1969)
[![Build status](https://ci.appveyor.com/api/projects/status/1a75hcaeijg9owc8?svg=true)](https://ci.appveyor.com/project/scivision/lunar-lander-1969)

# Lunar Lander 1969:  BASIC and Fortran

* [Jim Storer](http://www.cs.brandeis.edu/~storer/LunarLander/LunarLander.html), fall 1969: PDP-8 FOCAL
* David H. Ahl, 1973: [BASIC](http://www.cs.brandeis.edu/~storer/LunarLander/LunarLander/Articles/Rocket-101BasicComputerGames.pdf)

This game is presented in:

* BASIC `lunar.bas` adapted from the 1969 source code, compatible with modern ANSI BASIC interpreters.
* Fortran `lunar.f90` by Michael Hirsch is also given.

## Build
Any Fortran 2008 compliant compiler should work.
```sh
make
```

## Usage

The program defaults to stdin from user.
```sh
./lunar
```

Options:

* `-d` allows file redirection for testing and optimization
* `-f` specifies initial fuel weight

To mimic the 1969 results
```sh
./lunar -f 16000 -d < fail.asc

./lunar -f 16000 -d < ok.asc
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
