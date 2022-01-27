import os

settings = {
    'host': os.environ.get('ACCOUNT_HOST', 'https://asacosmosdbzoldgfa.documents.azure.com:443/'),
    'master_key': os.environ.get('ACCOUNT_KEY', 'IZ6ntHX6gbOJpTZjjaUm7AzL3aMJdRxcYis93YELyMEcvv1h0ObX1vtEAlyHRZH4KmdkKe8FPo58vfOLbOu1Fg=='),
    'database_id': os.environ.get('COSMOS_DATABASE', 'RaspberryData'),
    'container_id': os.environ.get('COSMOS_CONTAINER', 'raspdatahtap'),
}

