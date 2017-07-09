import pyspark
from application.util import metaphone_udf


if __name__ == '__main__':
    spark = (
        pyspark.sql.SparkSession.builder
        # This doesn't seem to have an impact on YARN.
        # Use `spark-submit --name` instead.
        # .appName('Sample Spark Application')
        .getOrCreate())
    names = (
        spark.createDataFrame(
            data=[
                ('Nick',),
                ('John',),
                ('Frank',),
            ],
            schema=['name']
        ))
    names.select('name', metaphone_udf('name')).show()
