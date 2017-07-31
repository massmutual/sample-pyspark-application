"""
We need this wrapper so that pytest runs within PySpark, allowing us
to test code that depends on Spark.

Any arguments to this script will just be passed through to pytest.
"""
import pytest
import sys


if __name__ == '__main__':
    sys.exit(
        pytest.main(
            sys.argv[1:]
        ))
