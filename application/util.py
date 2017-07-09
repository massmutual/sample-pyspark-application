"""
This is a dummy module that just wraps external code so we can
demonstrate in one go that both local and external dependencies
are accessible from YARN.
"""
import jellyfish
from pyspark.sql.types import StringType
from pyspark.sql.functions import udf


def metaphone(s: str) -> str:
    return jellyfish.metaphone(s)


metaphone_udf = udf(metaphone, StringType())
