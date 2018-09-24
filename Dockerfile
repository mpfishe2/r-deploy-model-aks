FROM rocker/r-ver

RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('randomForest')"
RUN mkdir app
COPY /files/plumber.R /app
COPY /files/mymodel.rda /app
EXPOSE 8000
ENTRYPOINT ["R", "-e", "r <- plumber::plumb('/app/plumber.R'); r$run(host='0.0.0.0', port=8000);"]
CMD ["/app/plumber.R"]
