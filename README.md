# matchbox on packet

This repository hosts a project to deploy [matchbox](https://github.com/coreos/matchbox) service on [packet](https://www.packet.com/).

You can deploy the service by following these steps.

1. Create a project
1. Allocate an elastic IP address
1. Generate certificate files
1. Start and provision a machine

## Create/Delete a project

### Create

```
$ make project.apply
```

### Delete

```
$ make project.destroy
```

## Allocate/Release an elastic IP

### Allocate

```
$ make elastic_ip.apply
```

### Release

```
$ make elastic_ip.destroy
```

## Create/Delete certificate files

### Create

```
$ make certificates.apply
```

### Delete

```
$ make certificates.destroy
```

## Start/Stop the matchbox service

### Start

```
$ make matchbox.apply
```

### Stop

```
$ make matchbox.destroy
```
