PACKAGE = fRanz
.PHONY: install test docs clean distclean cleanRcpp unlock build check

install: unlock clean cleanRcpp
	# Install fRanz R package
	Rscript -e 'if (!"Rcpp" %in% rownames(installed.packages())) {install.packages("Rcpp", repos = "https://cran.rstudio.com")}' && \
	Rscript -e "Rcpp::compileAttributes(file.path(getwd(),'$(PACKAGE)'))" && \
	Rscript -e 'if (!"devtools" %in% rownames(installed.packages())) {install.packages("devtools", repos = "https://cran.rstudio.com")}' && \
	Rscript -e "devtools::install(file.path(getwd(),'$(PACKAGE)'), force = TRUE, upgrade = FALSE)"

check: docs clean
	R CMD build fRanz
	R CMD check --as-cran `ls | grep  fRanz*.tar.gz`

cleanRcpp:
	rm -f fRanz/R/RcppExport.R fRanz/src/RcppExport.cpp

clean:
	# Remove cpp object files
	find $(PACKAGE)/src -name '*.o' -delete
	find $(PACKAGE)/src -name '*.so' -delete
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