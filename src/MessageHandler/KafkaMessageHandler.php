<?php

declare(strict_types=1);

namespace App\MessageHandler;

use App\Message\KafkaMessage;
use Psr\Log\LoggerInterface;
use Symfony\Component\Messenger\Attribute\AsMessageHandler;

#[AsMessageHandler]
final class KafkaMessageHandler
{
    public function __construct(private readonly LoggerInterface $logger)
    {
    }

    public function __invoke(KafkaMessage $message): void
    {
        $this->logger->info('KafkaMessage handled', ['topic' => $message->topic, 'payload' => $message->payload]);
    }
}
