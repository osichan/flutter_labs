import paho.mqtt.client as mqtt
import time
import random

broker = "broker.hivemq.com"
port = 1883
topic = "sensor/temperature"

client = mqtt.Client(client_id="python_publisher")
client.connect(broker, port)

while True:
    temperature = round(random.uniform(20.0, 30.0), 1)
    client.publish(topic, str(temperature))
    print(f"Published temperature: {temperature} °C")
    time.sleep(5)