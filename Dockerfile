# This is dockerization of the local development environment described in the AWS Glue docs:
# https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html#develop-local-python

# Install dependencies (Maven, zip)
FROM maven:3.6-alpine
RUN apk add zip

# Install Python
RUN apk add "python3=3.6.9-r2"
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python --version

# Install Spark distribution provided by AWS for Glue development
RUN wget -qO- https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-1.0/spark-2.4.3-bin-hadoop2.8.tgz | tar zxf - 2>/dev/null
RUN mv spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8 spark
ENV SPARK_HOME /spark

# Install awsglue library
RUN wget -qO- https://codeload.github.com/awslabs/aws-glue-libs/tar.gz/glue-1.0 | tar zxf -
ENV PATH="/aws-glue-libs-glue-1.0/bin:${PATH}"

# Install pytest
RUN pip3 install pytest
RUN pip3 install pytest-watch
COPY glueptw /aws-glue-libs-glue-1.0/bin/glueptw

# Bootstrap the AWS Glue environment (gluepytest will execute glue-setup.sh)
# This executes the copy-dependencies target in Maven and takes a while to complete
RUN gluepytest --version
