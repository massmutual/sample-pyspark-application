# Sample PySpark-on-YARN Application

This is a sample PySpark application which demonstrates how to 
dynamically package your dependencies and isolate your 
application from any other jobs running on a YARN cluster. With 
this pattern you don't need to rely on a shared virtual 
environment being deployed to each node of the cluster, which
becomes a point of contention when different applications that 
have incompatible dependencies try to share that same virtual 
environment.

This example builds on the discussion [@nchammas] had with 
several other PySpark users on [SPARK-13587].

[@nchammas]: https://github.com/nchammas/
[SPARK-13587]: https://issues.apache.org/jira/browse/SPARK-13587

## Running Locally

Although the point of this project is to demonstrate how to run
a self-contained PySpark application on a YARN cluster, you can
run it locally as follows:

```sh
python3 -m venv venv
source venv/bin/activate
pip install -U pip
pip install -r requirements.pip

spark-submit hello.py
```

## Running on YARN

To run this project on YARN, simply setup some environment variables
and you're good to go.

```sh
export HADOOP_CONF_DIR="/path/to/hadoop/conf"
export PYTHON="/path/to/python/executable"
export SPARK_HOME="/path/to/spark/home"
export PATH="$SPARK_HOME/bin:$PATH"

./setup-and-submit.sh
```
