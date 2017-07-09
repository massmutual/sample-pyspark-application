set -e
set -x

# Set $PYTHON to the Python executable you want to create
# your virtual environment with. It could just be something
# like `python3`, if that's already on your $PATH, or it could
# be a /fully/qualified/path/to/python.
test -n "$PYTHON"

# Make sure $SPARK_HOME is on your $PATH so that `spark-submit`
# runs from the correct location.
test -n "$SPARK_HOME"

"$PYTHON" -m venv venv
source venv/bin/activate
pip install -U pip
pip install -r requirements.pip
deactivate

# Here we package up an isolated environment that we'll ship to YARN.
# The awkward zip invocation is required to setup the correct relative
# paths for the contents of each package.
pushd venv/
zip -rq ../venv.zip *
popd
pushd application/
zip -rq ../application.zip *
popd

# We want YARN to use the Python from our virtual environment,
# which includes all our dependencies.
export PYSPARK_PYTHON="venv/bin/python"

# The --archives option places our packaged up environment on each
# YARN worker's lookup path with an alias that we define. The pattern
# is `local-file-name#aliased-file-name`. So when we set
# PYSPARK_PYTHON to `venv/bin/python`, `venv/` here references the
# aliased zip file we're sending to YARN.
spark-submit \
    --name "Sample Spark Application" \
    --master yarn \
    --deploy-mode client \
    --conf "spark.yarn.appMasterEnv.SPARK_HOME=$SPARK_HOME" \
    --conf "spark.yarn.appMasterEnv.PYSPARK_PYTHON=$PYSPARK_PYTHON" \
    --archives "venv.zip#venv,application.zip#application" \
    hello.py
