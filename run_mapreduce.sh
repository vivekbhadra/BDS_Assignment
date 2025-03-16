#!/bin/bash

# Set Variables
HADOOP_STREAMING_JAR="$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.2.4.jar"
INPUT_FILE="shakespeare.txt"
HDFS_INPUT_DIR="/user/vivekb/input"
HDFS_OUTPUT_DIR="/user/vivekb/output1"

echo "====== Starting Hadoop Cluster Setup ======"

# Check if NameNode is running, if not start it
if ! jps | grep -q NameNode; then
    echo "Starting NameNode..."
    hdfs --daemon start namenode
fi

# Check if DataNode is running, if not start it
if ! jps | grep -q DataNode; then
    echo "Starting DataNode..."
    hdfs --daemon start datanode
fi

# Start ZooKeeper if required
if ! jps | grep -q QuorumPeerMain; then
    echo "Starting ZooKeeper..."
    zkServer.sh start
fi

# Start ResourceManager
if ! jps | grep -q ResourceManager; then
    echo "Starting ResourceManager..."
    yarn --daemon start resourcemanager
fi

# Start NodeManager
if ! jps | grep -q NodeManager; then
    echo "Starting NodeManager..."
    yarn --daemon start nodemanager
fi

# Check if HBase is running
if ! jps | grep -q HMaster; then
    echo "Starting HBase..."
    /opt/hbase-2.4.15/bin/start-hbase.sh
fi

echo "====== Hadoop Services Started Successfully ======"

# Check Safe Mode
if hdfs dfsadmin -safemode get | grep -q "ON"; then
    echo "Safe Mode is ON. Disabling..."
    hdfs dfsadmin -safemode leave
fi

# Verify Cluster Health
echo "====== Checking HDFS Health ======"
hdfs dfsadmin -report

# Check for Missing Blocks and Attempt Repair
if hdfs fsck / | grep -qi 'MISSING'; then
    echo "Detected missing blocks. Running repair..."
    hbase hbck -repair
fi

# Ensure HDFS directory exists
hdfs dfs -mkdir -p "$HDFS_INPUT_DIR"

# Upload input file if not already present
if ! hdfs dfs -test -e "$HDFS_INPUT_DIR/$INPUT_FILE"; then
    echo "Uploading $INPUT_FILE to HDFS..."
    hdfs dfs -put "$INPUT_FILE" "$HDFS_INPUT_DIR/"
else
    echo "$INPUT_FILE already exists in HDFS."
fi

# Remove old output directory if it exists
if hdfs dfs -test -d "$HDFS_OUTPUT_DIR"; then
    echo "Removing existing output directory: $HDFS_OUTPUT_DIR"
    hdfs dfs -rm -r "$HDFS_OUTPUT_DIR"
fi

echo "====== Running Hadoop MapReduce Job ======"

# Execute Hadoop Streaming MapReduce
hadoop jar "$HADOOP_STREAMING_JAR" \
    -files mapper.py,reducer.py \
    -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" \
    -input "$HDFS_INPUT_DIR/$INPUT_FILE" \
    -output "$HDFS_OUTPUT_DIR"

# Check if job succeeded
if [ $? -eq 0 ]; then
    echo "MapReduce job completed successfully!"
    echo "Top 20 words from output:"
    hdfs dfs -cat "$HDFS_OUTPUT_DIR/part-00000" | head -20
else
    echo "MapReduce job failed. Check logs for errors."
fi

