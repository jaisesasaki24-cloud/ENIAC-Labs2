import json
from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'orden-eventos',
    bootstrap_servers=['kafka:9092'],
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    group_id='eniaclabs-py-consumer',
    key_deserializer=lambda k: k.decode('utf-8') if k else None
)

print("[Python Consumer] Escuchando topic 'orden-eventos' (grupo: eniaclabs-py-consumer)...")

try:
    for message in consumer:
        raw_val = message.value.decode('utf-8') if message.value else ""
        try:
            payload = json.loads(raw_val)
            print(json.dumps({
                "component": "consumer",
                "eventType": payload.get("tipoEvento", "unknown"),
                "ordenId": payload.get("ordenId"),
                "idCliente": payload.get("idCliente"),
                "metodoPago": payload.get("metodoPago"),
                "total": payload.get("total"),
                "partition": message.partition,
                "offset": message.offset,
                "status": "consumed"
            }))
        except json.JSONDecodeError as ex:
            print(json.dumps({
                "component": "consumer",
                "status": "invalid",
                "partition": message.partition,
                "offset": message.offset,
                "decodeError": str(ex),
                "rawPayload": raw_val
            }))
except KeyboardInterrupt:
    print("[Python Consumer] Detenido por el usuario.")
finally:
    consumer.close()
