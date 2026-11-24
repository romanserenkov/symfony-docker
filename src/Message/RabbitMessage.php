<?php

declare(strict_types=1);

namespace App\Message;

/**
 * Dispatched to RabbitMQ (transport: rabbit).
 */
final class RabbitMessage
{
    public function __construct(
        public readonly string $payload,
    ) {
    }
}
