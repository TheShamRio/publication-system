import logging
from logging.kafka_handler import KafkaLogHandler

def setup_logging():
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    kafka_handler = KafkaLogHandler(
        bootstrap_servers="kafka:9092",
        topic="app-logs",
    )

    logger.addHandler(kafka_handler)
