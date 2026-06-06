from azure.eventhub import EventHubProducerClient, EventData
from faker import Faker
import json, time, random
from datetime import datetime, timedelta
import os


fake = Faker()

CONNECTION_STRING = os.environ.get("EVENTHUB_CONNECTION_STRING")
EVENTHUB_NAME = os.environ.get("EVENTHUB_NAME")
# paste your values from the Event Hub tab here
  # the event hub name from the details tab

PRODUCTS = [
    {"product_id": 1, "name": "Wireless Headphones", "category": "electronics", "price": 59.99},
    {"product_id": 2, "name": "Running Shoes",       "category": "clothing",     "price": 89.99},
    {"product_id": 3, "name": "Gold Necklace",       "category": "jewelery",     "price": 299.99},
    {"product_id": 4, "name": "Coffee Maker",        "category": "home & kitchen","price": 45.00},
    {"product_id": 5, "name": "Smartwatch",          "category": "electronics",  "price": 199.99},
]

def random_timestamp():
    start = datetime(2001, 1, 1)
    end = datetime.utcnow()  # always today's date
    delta = end - start
    dt = start + timedelta(
        days=random.randint(0, delta.days),
        seconds=random.randint(0, 86400)
    )
    if random.random() < 0.15:
        return dt.strftime("%d/%m/%Y %H:%M")
    else:
        return dt.isoformat()

def generate_order():
    product = random.choice(PRODUCTS)
    quantity = random.randint(1, 5)
    return {
        "order_id":       random.randint(0, 100000),
        "user_id":        fake.uuid4() if random.random() > 0.1 else None,
        "user_name":      fake.name(),
        "user_email":     fake.email(),
        "user_city":      fake.city(),
        "user_country":   fake.country(),
        "product_id":     product["product_id"],
        "product_name":   product["name"],
        "category":       product["category"],
        "price":          str(product["price"]) if random.random() < 0.2 else product["price"],
        "quantity":       quantity,
        "total":          round(product["price"] * quantity, 2),
        "timestamp":      random_timestamp(),
        "payment_method": random.choice(["credit_card", "paypal", "cash", None]),
    }

# connect to Fabric Eventstream
producer = EventHubProducerClient.from_connection_string(
    conn_str=CONNECTION_STRING,
    eventhub_name=EVENTHUB_NAME
)

print("Starting order stream... Press Ctrl+C to stop")

while True:
    order = generate_order()
    
    event_batch = producer.create_batch()
    event_batch.add(EventData(json.dumps(order)))
    producer.send_batch(event_batch)
    
    print(f"✓ Sent order {order['order_id']} | {order['product_name']} | ${order['total']}")
    time.sleep(0.1)