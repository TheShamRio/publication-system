import json
import logging
from kafka import KafkaProducer
from datetime import datetime

class KafkaLogHandler(logging.Handler):
    def __init__(self, bootstrap_servers: str, topic: str):
        super().__init__()
        self.producer = KafkaProducer(
            bootstrap_servers=bootstrap_servers,
            value_serializer=lambda v: json.dumps(v).encode("utf-8"),
        )
        self.topic = topic

    def emit(self, record: logging.LogRecord):
        log_entry = {
            "level": record.levelname,
            "message": record.getMessage(),
            "logger": record.name,
            "timestamp": datetime.utcnow().isoformat(),
        }

        self.producer.send(self.topic, log_entry)
