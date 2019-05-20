PACKAGE = fRanz
.PHONY: install test docs clean distclean cleanRcpp unlock

install: unlock clean cleanRcpp
	# Install fRanz R package
	Rscript -e 'if (!"Rcpp" %in% rownames(installed.packages())) {install.packages("Rcpp", repos = "https://cran.rstudio.com")}' && \
	Rscript -e "Rcpp::compileAttributes(file.path(getwd(),'$(PACKAGE)'))" && \
	Rscript -e 'if (!"devtools" %in% rownames(installed.packages())) {install.packages("devtools", repos = "https://cran.rstudio.com")}' && \
	Rscript -e "devtools::install(file.path(getwd(),'$(PACKAGE)'), force = TRUE, upgrade = FALSE)"

cleanRcpp:
	rm -f fRanz/R/RcppExport.R fRanz/src/RcppExport.cpp

clean:
	# Remove cpp object files
	find $(PACKAGE)/src -name '*.o' -delete
	find $(PACKAGE)/src -name '*.so' -delete

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

librdkafka:
	wget https://github.com/edenhill/librdkafka/archive/v1.0.0.tar.gz -O librdkafka-1.0.0.tar.gz && \
	tar xzf librdkafka-1.0.0.tar.gz && \
	cd librdkafka-1.0.0 && \
	./configure && \
	$(MAKE) && \
	$(MAKE) install && \
	cd .. && rm -rf librdkafka-1.0.0; \