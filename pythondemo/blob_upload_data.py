import os
import datetime
import time
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient, __version__

import sensehat_datareader as sh

# https://pythonhosted.org/sense-hat/


connect_str="DefaultEndpointsProtocol=https;AccountName=su20220124storage;AccountKey=anMVTwdlQV3PLWcEDW8sc9ub2wrhH+l95NRcu6cs/o6p45xjJGsbold2LCLKjWqSbom7Lm1yCIntVypjvm3NgA==;EndpointSuffix=core.windows.net"




container_name="raspdata"


# Create a file in local data directory to upload and download
local_path = "./data"
fileMinutesCollect=2

sense=sh.sensehatReader()

while True:
    datoTekst=datetime.datetime.now().strftime('%Y_%m_%d_%H_%M_%S')
    local_file_name = "data" + datoTekst + ".csv"
    upload_file_path = os.path.join(local_path, local_file_name)
    data=sense.get_data()
    headerline=",".join(data.keys())    
    filecontent=headerline
    dataValues=[str(item) for item in data.values()]
    filecontent = filecontent + "\n" + ",".join(dataValues)

    currentTimestamp=datetime.datetime.now()
    endCollectTimestamp=currentTimestamp + datetime.timedelta(minutes=fileMinutesCollect)

    while currentTimestamp < endCollectTimestamp:
        time.sleep(2)    
        data=sense.get_data()
        dataValues=[str(item) for item in data.values()]
        dataline=",".join(dataValues)
        filecontent = filecontent + "\n" + dataline
        print(dataline)           
        currentTimestamp=datetime.datetime.now()
        
    # Write text to the file
    file = open(upload_file_path, 'w')
    file.write(filecontent)
    file.close()

    blob_service_client = BlobServiceClient.from_connection_string(connect_str)
    # Create a blob client using the local file name as the name for the blob
    blob_client = blob_service_client.get_blob_client(container=container_name, blob=local_file_name)

    print("\nUploading to Azure Storage as blob:\n\t" + local_file_name)

    # Upload the created file
    with open(upload_file_path, "rb") as data:
        blob_client.upload_blob(data)
        
    
