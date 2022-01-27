import datetime
from sense_hat import SenseHat


class sensehatReader:

    def __init__(self):
        self.sense = SenseHat()


    def get_data(self,timestampAttributeName="timestamp"):
        timestamp=datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S")    
        data = {
                'sensorid' : 1984,
                timestampAttributeName : timestamp,
                'temperature_from_humidity' : self.sense.get_temperature_from_humidity(),
                'temperature_from_pressure' : self.sense.get_temperature_from_pressure(),            
                'humidity' : self.sense.get_humidity(),
                'pressure' : self.sense.get_pressure()                        
                }
        return data

