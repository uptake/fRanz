PACKAGE = fRanz
.PHONY: install test docs clean distclean cleanRcpp unlock build check

install: docs
	R CMD INSTALL $(PACKAGE)

check: docs clean
	R CMD build fRanz
	R CMD check --as-cran `ls | grep  fRanz*.tar.gz`

cleanRcpp:
	rm -f fRanz/R/RcppExport.R fRanz/src/RcppExport.cpp

clean:
	# Remove cpp object files
	find $(PACKAGE)/src -name '*.o' -delete
	find $(PACKAGE)/src -name '*.so' -delete
	find $(PACKAGE)/src -name '*.a' -delete
	find $(PACKAGE)/src -name '*.dylib' -delete
	rm -r $(PACKAGE)/src/librdkafka 

distclean: clean cleanRcpp

unlock:
	# Remove 00LOCK directory
	for libpath in $$(Rscript -e "noquote(paste(.libPaths(), collapse = ' '))"); do \
		echo "Unlocking $$libpath..." && \
		rm -rf $$libpath/00LOCK-$(PACKAGE); \
	done

docs:
	# Regenerate documentation with roxygen
	Rscript -e "roxygen2::roxygenize('$(PACKAGE)')"
test:
	# Run unit tests
	Rscript -e "devtools::test('$(PACKAGE)')"
