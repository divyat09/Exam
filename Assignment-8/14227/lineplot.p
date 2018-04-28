#set term postscript eps enhanced monochrome 20 dashed dashlength 1 lw 1.5
set terminal postscript eps enhanced color

set key samplen 2 spacing 1.5 font ",22"

set xtics font ",22"
set ytics font ",22"
set ylabel font ",25"
set xlabel font ",25"

set xlabel "Number of Parameters"
set ylabel "Mean Execution Time"
set yrange[0:100000]
set xrange[0:1200000]
set ytic auto
set xtic auto

set key bottom right

set output "Mean_Execution_Time_Plot.eps"
plot 'D2_1.dat' using 1:2 title "Num Thread 1" with linespoints, \
	 'D2_2.dat' using 1:2 title "Num Thread 2" with linespoints, \
	 'D2_4.dat' using 1:2 title "Num Thread 4" with linespoints, \
	 'D2_8.dat' using 1:2 title "Num Thread 8" with linespoints, \
	 'D2_16.dat' using 1:2 title "Num Thread 16" with linespoints