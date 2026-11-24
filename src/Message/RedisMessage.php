<?php

declare(strict_types=1);

namespace App\Message;

/**
 * Dispatched to a Redis stream (transport: redis).
 */
final class RedisMessage
{
    public function __construct(
        public readonly string $payload,
    ) {
    }
}
