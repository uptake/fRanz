FROM rocker/r-base
ARG test

# For roxygen2
RUN apt-get update && apt-get install -y libxml2-dev 
RUN Rscript -e "install.packages(c('Rcpp','R6','testthat','uuid','roxygen2'))"

RUN echo "$test"
COPY ./fRanz fRanz

RUN R CMD build fRanz
RUN R CMD check --install-args='--no-clean-on-error' fRanz_0.1.0.tar.gz || cat fRanz.Rcheck/00install.out 