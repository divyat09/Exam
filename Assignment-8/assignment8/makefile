all:Report.pdf

makeReport Report.pdf: Scatter_1.eps Scatter_2.eps Scatter_4.eps Scatter_8.eps Scatter_16.eps Bar_Plot_Error.eps Bar_Plot.eps Mean_Execution_Time_Plot.eps Report.tex
	pdflatex Report.tex

makePlotBarError Bar_Plot_Error.eps:D4_1.dat D4_2.dat D4_4.dat D4_8.dat D4_16.dat plot_speedup_error.p
	gnuplot plot_speedup_error.p

makePlotBar Bar_Plot.eps: D3_1.dat D3_2.dat D3_4.dat D3_8.dat D3_16.dat plot_speedup.p
	gnuplot plot_speedup.p

makeLinePLot Mean_Execution_Time_Plot.eps: D2_1.dat D2_2.dat D2_4.dat D2_8.dat D2_16.dat lineplot.p
	gnuplot lineplot.p

makeScatterPlot Scatter_1.eps Scatter_2.eps Scatter_4.eps Scatter_8.eps Scatter_16.eps: D1_1.dat D1_2.dat D1_4.dat D1_8.dat D1_16.dat scatter.p
	gnuplot scatter.p

makeAnalyseBarError D4_1.dat D4_2.dat D4_4.dat D4_8.dat D4_16.dat: T_1.dat T_2.dat T_4.dat T_8.dat T_16.dat Analyse4.py 
	python Analyse4.py

makeAnalyseBar D3_1.dat D3_2.dat D3_4.dat D3_8.dat D3_16.dat: T_1.dat T_2.dat T_4.dat T_8.dat T_16.dat Analyse3.py 
	python Analyse3.py

makeAnalyseLine D2_1.dat D2_2.dat D2_4.dat D2_8.dat D2_16.dat: T_1.dat T_2.dat T_4.dat T_8.dat T_16.dat Analyse2.py 
	python Analyse2.py

makeAnalyseScatter D1_1.dat D1_2.dat D1_4.dat D1_8.dat D1_16.dat: T_1.dat T_2.dat T_4.dat T_8.dat T_16.dat Analyse1.py 
	python Analyse1.py

makeData T_1.dat T_2.dat T_4.dat T_8.dat T_16.dat: makeApp generate_stat.sh params.txt threads.txt
	bash generate_stat.sh params.txt threads.txt

makeApp:makeApp1.o makeApp2.o
	gcc -o makeApp makeApp1.o makeApp2.o -lm -lpthread

makeApp1.o:thread_function.c
	gcc -c thread_function.c -o makeApp1.o -lm -lpthread

makeApp2.o:prog.c thread_function.c
	gcc -c prog.c -o makeApp2.o -lm -lpthread

clean: 
	rm -f *.eps *.o *.dat *.aux *.log *.pdf makeApp