<?php

declare(strict_types=1);

namespace App\MessageHandler;

use App\Message\RedisMessage;
use Psr\Log\LoggerInterface;
use Symfony\Component\Messenger\Attribute\AsMessageHandler;

#[AsMessageHandler]
final class RedisMessageHandler
{
    public function __construct(private readonly LoggerInterface $logger)
    {
    }

    public function __invoke(RedisMessage $message): void
    {
        $this->logger->info('RedisMessage handled', ['payload' => $message->payload]);
    }
}
