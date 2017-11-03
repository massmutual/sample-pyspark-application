# Sample PySpark-on-YARN Application

This sample PySpark application demonstrates how to
dynamically package your Python dependencies and isolate your
application from any other jobs running on a YARN cluster.
It builds on the discussion [@nchammas] had with several other
PySpark users on [SPARK-13587]. The key pattern is captured in
`setup-and-submit.sh`.

This sample application also demonstrates how to structure and run
your Spark tests, both locally and on Travis CI.

[@nchammas]: https://github.com/nchammas/
[SPARK-13587]: https://issues.apache.org/jira/browse/SPARK-13587

## Approach

The gist of the approach is to use `spark-submit`'s `--archives`
option to ship a complete Python virtual environment (Conda works
too!) to all your YARN executors, isolated to a specific application.
This lets you use any version of Python and any
combination of Python libraries with your application, without
requiring them to be pre-installed on your cluster. More
importantly, this lets PySpark applications with conflicting
dependencies run side-by-side on the same YARN cluster without
issue.

## Caveats

The main downside of this approach is that the setup and
distribution of the virtual environment adds many seconds -- or even
minutes, depending on the size of the environment -- to the job's
initialization time. So depending on your job latency requirements
and the complexity of your environment, this approach may not be
worth it to you.

This approach also does not cover any non-Python dependencies your
PySpark application may have unless a) they are Java or Scala
dependencies, which `spark-submit` already supports via `--packages`;
or b) they are Conda or [`manylinux`] packages, which your
Python package manager puts in your virtual environment for you.

A typical example of a dependency this approach won't handle is a 
standalone C library that you need to install using your Linux 
distribution's package manager.
If you want to isolate non-Python dependencies like this to
your application, you need to look into deployment options
that somehow leverage Linux containers.

[`manylinux`]: https://www.python.org/dev/peps/pep-0513/

## Running Tests

Run this project's tests as follows:

```sh
spark-submit run_tests.py
```

Normally, with pytest, you'd do this to run your tests:

```sh
PYTHONPATH=./ pytest
```

However, this won't work here since we need pytest to run within
PySpark. Spark 2.2.0 added [support for pip installation], which may
simplify this pattern. However, we won't use it here.

[support for pip installation]: http://spark.apache.org/releases/spark-release-2-2-0.html

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

To run this project on YARN, simply set some environment variables
and you're good to go.

```sh
export HADOOP_CONF_DIR="/path/to/hadoop/conf"
export PYTHON="/path/to/python/executable"
export SPARK_HOME="/path/to/spark/home"
export PATH="$SPARK_HOME/bin:$PATH"

./setup-and-submit.sh
```

The key pattern for packaging your PySpark application is captured in
`setup-and-submit.sh`.
