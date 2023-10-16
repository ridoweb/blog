---
title: Tamples are test samples
layout: post
date: 2023-04-14
---

While working on an IoT solution, I've found the need to have samples to validate the _device side_ application. These are relatively simple applications that connect to an MQTT endpoint and perform some pub/sub operations.

The samples are great, but they require manual intervention, so they cannot be considered proper _tests_, also they dont have assertions !!

Additionally, we want to validate the full solution, by making sure that the _service side_ application can communicate with those devices by connecting to the same MQTT broker.

## Introducing _Tamples_

So let me introduce what _Tamples_ are.

1. Are small applications that can be used as samples to illustrate how to use the APIs used to build IoT devices.
2. Are expected to be always connected, if they are not it's because there is a failure in the system. 
3. Implement a well-known behavior, in terms of Properties, Telemetries and Commands as defined by the [IoT Pattern](./2022-10-02-the-iot-pattern.md)

Now I can write _e2e_ tests assuming the tamples are there, listening to command invocations, so I can write the assertions based on the well-known behavior.


