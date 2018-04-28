set term postscript eps enhanced monochrome 20 dashed dashlength 1 lw 1.5
#set terminal postscript eps enhanced color

set key samplen 2 spacing 1 font ",22"

set xtics font ",22"
set ytics font ",22"
set ylabel font ",25"
set xlabel font ",25"

#set format y "10^{%L}"
set logscale x 10
set xlabel "Number of Parameteres"
set ylabel "Execution Time"
set yrange[0:100000]
set xrange[10:100000000]
set ytic auto
set xtic auto

set output "Scatter_1.eps"
plot 'D1_1.dat' using 1:2 notitle with points pt 1 ps 1.5

set output "Scatter_2.eps"
plot 'D1_2.dat' using 1:2 notitle with points pt 1 ps 1.5

set output "Scatter_4.eps"
plot 'D1_4.dat' using 1:2 notitle with points pt 1 ps 1.5

set output "Scatter_8.eps"
plot 'D1_8.dat' using 1:2 notitle with points pt 1 ps 1.5

set output "Scatter_16.eps"
plot 'D1_16.dat' using 1:2 notitle with points pt 1 ps 1.5
