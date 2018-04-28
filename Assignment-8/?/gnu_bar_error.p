reset
fontsize = 12
set term postscript enhanced eps fontsize
set output "bargraph_solid_state.eps"
set style fill solid 1.00 border 0
set style histogram errorbars gap 2 lw 1
set style data histogram
set xtics rotate by -45
set grid ytics
set xlabel "Benchmarks"
set ylabel "Relative execution time vs. reference implementation"
set yrange [0:*]
set datafile separator ","
plot 'bm_analysis_results.dat' using 2:3:xtic(1) ti "Rapydo" linecolor rgb "#FF0000", \
'' using 4:5 ti "R reference implementation" lt 1 lc rgb "#00FF00"