set term postscript eps enhanced monochrome 20 dashed dashlength 1 lw 1.5
#set terminal postscript eps enhanced color

set key samplen 2 spacing 1 font ",22"

set xtics font ",22"
set ytics font ",22"
set ylabel font ",25"
set xlabel font ",25"

#set format y "10^{%L}"
set xlabel "Number of elements"
set ylabel "Running Time"
set yrange[0:10]
set xrange[0:5]
set ytic auto
set xtic auto


set output "scatter.eps"
plot 'trial.out' using 1:2 notitle with points pt 1 ps 1.5

