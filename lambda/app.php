<?php

function handler($event, $context)
{
    echo json_encode($context);
    $event['queryStringParameters']['PHP_VERSION'] = phpversion();
    return response("queryStringParameters, " . json_encode($event['queryStringParameters']));
}

function response($body)
{
    $headers = [
        "Content-Type" => "application/json"
    ];
    return json_encode([
        "statusCode" => 200,
        "headers" => $headers,
        "body" => $body
    ]);
}