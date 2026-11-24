<?php

declare(strict_types=1);

namespace App\MessageHandler;

use App\Message\RabbitMessage;
use Psr\Log\LoggerInterface;
use Symfony\Component\Messenger\Attribute\AsMessageHandler;

#[AsMessageHandler]
final class RabbitMessageHandler
{
    public function __construct(private readonly LoggerInterface $logger)
    {
    }

    public function __invoke(RabbitMessage $message): void
    {
        $this->logger->info('RabbitMessage handled', ['payload' => $message->payload]);
    }
}
