source synopsys_tools.sh;
rm -rfv `ls |grep -v ".*\.sv\|.*\.sh"`;

#vcs -Mupdate Test_Power.sv  -o salida -full64 -debug_all -sverilog -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert;
#vcs -Mupdate Test_fifo.sv  -o salida -full64 -debug_all -sverilog -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert;
#vcs -Mupdate prueba_modulo_driver.sv  -o salida -full64 -debug_all -sverilog -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert;
vcs -Mupdate test_bench.sv  -o salida -full64 -debug_all -sverilog -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert;

./salida -cm line+tgl+cond+fsm+branch+assert;
dve -full64 -covdir salida.vdb &
