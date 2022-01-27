import azure.cosmos.documents as documents
import azure.cosmos.cosmos_client as cosmos_client
import azure.cosmos.exceptions as exceptions
from azure.cosmos.partition_key import PartitionKey
import datetime
import time
import azure_config as config
import sensehat_datareader as sh

# ----------------------------------------------------------------------------------------------------------
# Prerequistes -
#
# 1. An Azure Cosmos account -
#    https://docs.microsoft.com/azure/cosmos-db/create-cosmosdb-resources-portal#create-an-azure-cosmos-db-account
#
# 2. Microsoft Azure Cosmos PyPi package -
#    https://pypi.python.org/pypi/azure-cosmos/
# ----------------------------------------------------------------------------------------------------------
# Sample - demonstrates the basic CRUD operations on a Item resource for Azure Cosmos
# ----------------------------------------------------------------------------------------------------------

HOST = config.settings['host']
MASTER_KEY = config.settings['master_key']
DATABASE_ID = config.settings['database_id']
CONTAINER_ID = config.settings['container_id']


def create_items(container):
    
    sense=sh.sensehatReader()
    while True:
        data=sense.get_data(timestampAttributeName="id")
        print(data)
        container.create_item(body=data)
        time.sleep(2)




def scale_container(container):
    print('Scaling Container')
    
    # You can scale the throughput (RU/s) of your container up and down to meet the needs of the workload. Learn more: https://aka.ms/cosmos-request-units
    
    offer = container.read_offer()
    print('Found Offer and its throughput is \'{0}\''.format(offer.offer_throughput))

    offer.offer_throughput += 100
    container.replace_throughput(offer.offer_throughput)

    print('Replaced Offer. Offer Throughput is now \'{0}\''.format(offer.offer_throughput))

def query_items(container, account_number):
    print('\n1.4 Querying for an  Item by Partition Key\n')

    # Including the partition key value of account_number in the WHERE filter results in a more efficient query
    items = list(container.query_items(
        query="SELECT * FROM r WHERE r.account_number=@account_number",
        parameters=[
            { "name":"@account_number", "value": account_number }
        ]
    ))

    print('Item queried by Partition Key {0}'.format(items[0].get("id")))



def run():
    client = cosmos_client.CosmosClient(HOST, {'masterKey': MASTER_KEY}, user_agent="CosmosDBDotnetQuickstart", user_agent_overwrite=True)
    try:

        db= client.get_database_client(DATABASE_ID)
        container = db.get_container_client(CONTAINER_ID)


      #  scale_container(container)
        create_items(container)
    
    except exceptions.CosmosHttpResponseError as e:
        print('\ncosmosdb insert data caught an error. {0}'.format(e.message))


run()
