module game

use iso_fortran_env, only: wp=>real64, stdin=>input_unit, stderr=>error_unit
implicit none

logical :: debug=.false.
real(wp), parameter :: maxburn = 200._wp, z=1.8, G=1e-3, Wdry=16500
real(wp) :: altitude, AltIncr, Wwet, burnrate, Vvel, Vincr, Tincr

contains

subroutine updateparams(L, T)

real(wp), intent(inout) :: L, T


L=L+Tincr
T=T-Tincr
Wwet = Wwet - Tincr*burnrate
altitude=AltIncr
Vvel=Vincr

end subroutine updateparams


subroutine step370(L, T)

real(wp), intent(inout) :: L, T
real(wp) :: W

W=(1-Wwet*G/(Z*burnrate))/2
Tincr=Wwet*Vvel/(Z*burnrate*(W+sqrt(W**2+Vvel/Z)))+.05_wp

call calc420

IF (AltIncr<=0) call landing(L, T)

call updateparams(L, T)

end subroutine step370


subroutine loop370(L, T)

real(wp), intent(inout) :: L, T

call step370(L, T)
if (Vincr>0) return
do while (Vvel>0 .and. Vincr<=0) 
  call step370(L, T)
end do

end subroutine loop370


subroutine calc420()

real(wp) :: Q

Q = Tincr*burnrate/Wwet

Vincr = Vvel + G*Tincr + Z*(-Q-Q**2/2-Q**3/3-Q**4/4-Q**5/5)

AltIncr = altitude - G*Tincr**2/2 - Vvel*Tincr + Z*Tincr*(Q/2+Q**2/6+Q**3/12+Q**4/20+Q**5/30)

end subroutine calc420


subroutine landing(L, T)

real(wp), value :: L, T
real(wp) :: D

do while (Tincr>=5e-3) 

  D = Vvel + sqrt(Vvel**2 + 2*altitude*(G-Z*burnrate/Wwet))
  Tincr = 2*altitude/D
  call calc420()
  call updateparams(L, T)

end do

call landed(L)

end subroutine landing


subroutine landed(L)

real(wp), intent(in) :: L
real(wp) :: W

W=3600*Vvel
PRINT '(a,f12.2,a)', "ON THE MOON AT ",L," SECONDS"
print '(a,f12.2,a)', "IMPACT VELOCITY OF ",W," MPH"

IF (W<=1.2) THEN
  print *, "PERFECT LANDING!"
  print '(a7,a7,a12)',"SEC","MPH","LB FUEL"
  print '(f7.2,f7.2,f12.2)', L, W, Wwet-Wdry
  stop
elseif (W<=10) THEN
  print *, "GOOD LANDING (COULD BE BETTER)"
  print '(a7,a7,a12)',"SEC","MPH","LB FUEL"
  print '(f7.2,f7.2,f12.2)', L, W, Wwet-Wdry
  stop
elseif (w<=60) then
  print *, "CRAFT DAMAGE: YOU'RE STRANDED HERE UNTIL A RESCUE PARTY ARRIVES. HOPE YOU HAVE ENOUGH OXYGEN!"
  print '(a7,a7,a12)',"SEC","MPH","LB FUEL"
  print '(f7.2,f7.2,f12.2)', L, W, Wwet-Wdry
  stop 1
else
  PRINT *, "SORRY THERE WERE NO SURVIVORS."
  print *,"YOU BLEW IT! IN FACT, YOU BLASTED A NEW LUNAR CRATER"
  print '(f12.2,a)', W*0.227_wp," FEET DEEP!"
  print '(a12,a12,a12)',"SEC","MPH","LB FUEL"
  print '(f12.2,f12.2,f12.2)', L, W, Wwet-Wdry
  stop 2
endif

end subroutine landed


real(wp) function burn(L)

real(wp), intent(in) :: L
integer :: i

write(*, '(f5.0,i6,i5,f7.0,f12.0, 6x)', advance='no') L, int(altitude), int(5280*modulo(altitude,1._wp)), 3600*Vvel, Wwet-Wdry

read(stdin,*,iostat=i) burn
if (i<0) stop 'Landing aborted per user request.'

if (i/=0 .or. burn < 0) then
  burn = 0
  write(stderr,'(a,f9.2)') 'burn specification not possiblee, using burnrate',burn 
elseif(burn > maxburn) then
  burn = maxburn
  write(stderr,'(a,f9.2)') 'burn specification not possible, using burnrate',burn
endif

if (debug) print '(f5.1)', burn

end function burn


subroutine fuelempty(L)

real(wp), value :: L

print '(a,f7.2,a)', "FUEL RAN OUT AT ",L," SECONDS"
Tincr=(-Vvel+sqrt(Vvel**2+2*altitude*G))/G

Vvel = Vvel + G*Tincr
L = L+Tincr

call landed(L)

end subroutine fuelempty

end module game


program lunar

use game
implicit none

real(wp) :: L, T, Wfuel
integer :: k
character(8) :: buf

Wfuel=16500
do k = 1,command_argument_count()
call get_command_argument(k,buf)
  select case (buf)
  case ('-d')
    debug=.true.
  case ('-f')
    call get_command_argument(k+1, buf)
    read(buf,*) Wfuel
  end select
end do

print '(33x,a)', "LUNAR"
print '(15x,a)', "CREATIVE COMPUTING MORRISTOWN, NEW JERSEY"
print *, ''
print *, "THIS IS A COMPUTER SIMULATION OF AN APOLLO LUNAR LANDING CAPSULE."
print *, "THE ON-BOARD COMPUTER HAS FAILED (IT WAS MADE BY XEROX) SO YOU HAVE TO LAND THE CAPSULE MANUALLY."
print *, ''
print *, "SET BURN RATE OF RETRO ROCKETS TO ANY VALUE BETWEEN "
print '(a,f7.0,a)', "0 (FREE FALL) AND ",maxburn," (MAXIMUM BURN) POUNDS PER SECOND."
print *, "SET NEW BURN RATE EVERY 10 SECONDS."

L=0
altitude=120
Vvel=1
Wwet = Wdry+Wfuel
T=10

print '(a,f7.0,a)', "CAPSULE WET WEIGHT ",Wwet," LBS"
print '(a,f7.0,a)', "FUEL WEIGHT ", Wwet-Wdry, " LBS."


print *, ''
print '(a5,a11,a7,a12,a15)',"SEC","MI + FT","MPH","LB FUEL", "BURN RATE"
print *,''


burnrate = burn(L)

do
if (Wwet-Wdry<1e-3) call fuelempty(L)

if (T<1e-3) then
  T = 10
  burnrate = burn(L)
  cycle
endif

Tincr=T
IF (Wwet < Wdry+Tincr*burnrate) Tincr = (Wwet-Wdry)/burnrate

call calc420()
IF (AltIncr<=0) exit

IF (Vvel<=0) THEN
  call updateparams(L, T)
  cycle
elseif (Vincr<0) THEN
  call loop370(L, T)
  cycle
else
  call updateparams(L, T)
  cycle
endif

call loop370(L, T)

enddo

call landing(L, T)

end program

