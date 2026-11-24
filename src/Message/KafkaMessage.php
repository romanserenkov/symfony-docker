<?php

declare(strict_types=1);

namespace App\Message;

/**
 * Dispatched to Kafka (transport: kafka, requires ext-rdkafka).
 */
final class KafkaMessage
{
    public function __construct(
        public readonly string $topic,
        public readonly string $payload,
    ) {
    }
}
