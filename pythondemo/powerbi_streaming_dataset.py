import requests
import json
import time

import sensehat_datareader as sh

sense=sh.sensehatReader()

# copy "Push URL" from "API Info" in Power BI
url="https://api.powerbi.com/beta/ecf3e66d-158c-4f9e-ab85-adad5304c0bf/datasets/9e6c19a9-6326-493e-aff0-853158ecdf19/rows?key=vlOqoE3lBoBDYkGmQhN9hp%2FmlLwFBKUzITaqU%2B7x3UuiQj7qZWZMEKe%2FXD5q6w%2BvfX7rdYAuKL4zO8xrt8qGEA%3D%3D"
while True:
    dataSense=sense.get_data()

    data = [dataSense]
    #print(data)

    # post/push data to the streaming API
    headers = {
      "Content-Type": "application/json"
      }
    response = requests.request(
        method="POST",
        url=url,
        headers=headers,
        data=json.dumps(data)
    )
    print(response)
    time.sleep(3)