all:    binary

binary: 
	mkdir -p bin/
	cp src/lexer.py bin/lexer.py
	cp src/symbol_table.py bin/symbol_table.py
	cp src/TAC.py bin/TAC.py
	cp src/parser.py bin/irgen
	sudo chmod +x bin/irgen
	sudo chmod +x bin
clean:
	find . -type f -name '*.swp' -delete; \
        find . -type f -name '*.pyc' -delete; \
        rm -rf *.o *.s *.S *.out *.html
	sudo rm -r bin


