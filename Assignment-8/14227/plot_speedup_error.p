#set terminal postscript eps enhanced color size 3.9,2.9
set term postscript eps enhanced monochrome 20 dashed dashlength 1 lw 1.5
set output "speedup.eps"

set key font ",22"
set xtics font ",22"
set ytics font ",22"
set ylabel font ",25"
set xlabel font ",25"
set xlabel "Num Paramas"
set ylabel "Thread Speedup"
set yrange[0:]
set ytic auto
set boxwidth 1 relative
set style data histograms
set style histogram cluster
set style fill pattern border
set style histogram errorbars lw 4
set style data histogram
set term postscript eps enhanced monochrome 20 dashed dashlength 1 lw 1.5


set output "Bar_Plot_Error.eps"
plot [-1:4][0:3] 'D4_1.dat' u 2:3 title "Num Thread 1" with histogram, 'D4_2.dat' u 2:3 title "Num Thread 2"  with histogram, 'D4_4.dat' u 2:3 title "Num Thread 4"  with histogram, 'D4_8.dat' u 2:3 title "Num Thread 8"  with histogram, 'D4_16_SpeedUpCase.dat' u 2:3 title "Num Thread 16"  with histogram
