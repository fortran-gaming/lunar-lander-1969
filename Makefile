lunar: lunar.f90
	$(FC) -g $^ -o $@

clean:
	$(RM) *.mod lunar

test:
	./lunar -d -f 16000 < good.asc
