#!/bin/sh

# cp /usr/games/mednafen-09x.cfg ${MEDNAFEN_HOME}/

# Launch the process in background, record the PID into a file, wait
# for the process to terminate and erase the recorded PID
picoarch /mnt/FunKey/.sdlretro/cores/mednafen_ngp_libretro.so "$1"&
pid record $!
wait $!
pid erase
