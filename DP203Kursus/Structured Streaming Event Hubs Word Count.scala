// Databricks notebook source
// MAGIC %md
// MAGIC 
// MAGIC This is a WordCount example with the following:
// MAGIC * Event Hubs as a Structured Streaming Source
// MAGIC * Stateful operation (groupBy) to calculate running counts
// MAGIC 
// MAGIC #### Requirements
// MAGIC 
// MAGIC * Databricks version 3.5 or 4.0 and beyond. 

// COMMAND ----------



// COMMAND ----------

import org.apache.spark.eventhubs.{ ConnectionStringBuilder, EventHubsConf, EventPosition }
import org.apache.spark.sql.functions.{ explode, split }

// To connect to an Event Hub, EntityPath is required as part of the connection string.
// Here, we assume that the connection string from the Azure portal does not have the EntityPath part.
val connectionString = ConnectionStringBuilder("Endpoint=sb://eventhub20220127.servicebus.windows.net/;SharedAccessKeyName=databrickslisten;SharedAccessKey=pYeCijltQ7ZUx1iJvJjIettpYHI1LhSi6JTw7EkNugI=")
  .setEventHubName("wordcounteventhub")
  .build
val eventHubsConf = EventHubsConf(connectionString)
  .setStartingPosition(EventPosition.fromEndOfStream)
  
val eventhubs = spark.readStream
  .format("eventhubs")
  .options(eventHubsConf.toMap)
  .load()

// COMMAND ----------

display(eventhubs)

// COMMAND ----------

// split lines by whitespaces and explode the array as rows of 'word'
val df = eventhubs.select(explode(split($"body".cast("string"), " ")).as("word"))
  .groupBy($"word")
  .count

// COMMAND ----------

display(df)

// COMMAND ----------

import org.apache.spark.sql.functions._

// split lines by whitespaces and explode the array as rows of 'word'
val df = eventhubs.select($"enqueuedTime",explode(split($"body".cast("string"), " ")).as("word"))
  .groupBy(window($"enqueuedTime", "2 minutes", "1 minutes"),$"word")
  .count

// COMMAND ----------

display(df)

// COMMAND ----------

// follow the word counts as it updates
display(df.select($"word", $"count"))

// COMMAND ----------

df.writeStream.queryName("aggregates").outputMode("complete").format("memory").start()

// COMMAND ----------

// MAGIC %sql
// MAGIC select * from aggregates

// COMMAND ----------

// MAGIC %sql
// MAGIC DESCRIBE TABLE EXTENDED aggregates

// COMMAND ----------

// MAGIC %md
// MAGIC 
// MAGIC ### Try it yourself
// MAGIC 
// MAGIC The Event Hubs Source also includes the ingestion timestamp of records. Try counting the words by the ingestion time window as well.
