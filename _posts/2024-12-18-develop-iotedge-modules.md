---
title: Developing IoTEdge Modules
layout: post
date: 2023-12-18
---

Azure IoT Hub includes support for IoT Edge, a runtime to run custom workload as Modules.

There has been different tools to help with this task, for Visual Studio, Visual Studio code and even a CLI to help with the most common developer tasks.

However, most of these tools are in _maintenance_ mode, with no major investments.

# An alternative approach to develop IoTEdge modules

A module is just an application, running as a docker container, that communicates with the a system module called $edgeHub. To develop a module we need a local instance of $edgeHub that we can target from the machine we use to develop.

In this post, I'm exploring a different approach to configure your workstation so you can develop and debug modules with your favourite IDE, although we are exploring only dotnet modules with Visual Studio in Windows and VSCode in Linux.

# How to run $edgeHub locally

$edge hub is available as a docker image in `mcr.microsoft.com/azureiotedge-hub:1.4`, before being able to run it we need to perform some pre-liminary tasks: 

- Initialize the $edgeHub  identity in Azure IoT Hub
- Configure $edgeHub module twin
- Provide certificates to configure the TLS connection

## Provisioning $edgeHub

When you create an IoT Edge device identity in Azuere IoT Hub, it will include the module identities for $edgeAgent and $edgeHub system modules. However, the modules are not _initialized_ and do not include the connection string we will need to configure our local instance of $edgeHub. 

In a _real_ environment, this iotedge runtime takes care of initializing the system modules, however it implies to connect, at least one time, the iotedge runtime.

Instead, I'm using a CLI tool called `aziotedge-modinit` to initialize the $edgeHub module, so we can get the connection string.

```bash
sasKey=$(az iot hub device-identity show -n $HUB_ID -d $EDGE_ID --query authentication.symmetricKey.primaryKey -o tsv)

aziotedge-modinit --moduleId='$edgeHub' --ConnectionStrings:IoTEdge="HostName=$HUB_ID.azure-devices.net;DeviceId=$EDGE_ID;SharedAccessKey=$sasKey" 
```

## Configuring $edgeHub

At startup, $edgeHub requires two properties to be configured in the module twin, however as this is a system module, we cannot update the twin, neither using the portal, or the CLI. 

```json
 "$edgeHub": {
    "properties.desired": {
        "schemaVersion": "1.1",
            "storeAndForwardConfiguration": {
                "timeToLiveSecs": 7200
            },
            "routes": {}
        }
    }
```

The only workaround I've found, is to invoke the `SetModules` operation, using a default deployment manifest, which includes the expected Twin Properties.

```bash
az iot edge set-modules -n $HUB_ID -d $EDGE_ID -k deploy.json
```

> Or you can use the portal and follow the SetModules screens with all default values.  

## Certificates for local development with dotnet dev-certs

The system modules expose endpoints protected by a TLS connection, to configure the TLS we need to provide an X509 certificate. This certificate can be the same certificate aspnet uses to provide a local TLS connection.

The next script creates a certificate for localhost and exports the public and private keys as .PEM and .KEY files, then we can use those files to configure the docker instance.

```bash
dotnet dev-certs https -ep _certs/localhost.pem --format PEM --no-password
cp _certs/localhost.pem _certs/ca.pem
```

## Running $edgeHub locally with docker

Now that we have the certs, and the $edgeHub connection string, we can run the docker container with:

```bash

connStr=$(az iot hub module-identity connection-string show -n $hub -d $edgeId -m '$edgeHub' --query connectionString -o tsv)

docker run -it --rm \
    -e IotHubConnectionString="$connStr" \
    -e EdgeModuleHubServerCertificateFile=/certs/localhost.pem \
    -e EdgeModuleHubServerCAChainCertificateFile=/certs/ca.pem \
    -e EdgeHubDevServerCertificateFile=/certs/localhost.pem \
    -e EdgeHubDevTrustBundleFile=/certs/ca.pem \
    -e EdgeHubDevServerPrivateKeyFile=/certs/localhost.key \
    -v ${pwd}/_certs:/certs \
    -p 8883:8883 \
    mcr.microsoft.com/azureiotedge-hub:1.4
```

If everything goes as expected, you should see this output.

