<p align="center">
  <img src="https://github.com/Starbix/dockerimages/raw/master/homebridge/homekit-logo.png">
</p>

[![](https://images.microbadger.com/badges/image/starbix/homebridge.svg)](https://microbadger.com/images/starbix/homebridge)
[![](https://images.microbadger.com/badges/version/starbix/homebridge.svg)](https://microbadger.com/images/starbix/homebridge)

## Description
What is **[Homebridge](https://github.com/nfarina/homebridge)**?

Homebridge is a lightweight NodeJS server you can run on your home network that emulates the iOS HomeKit API. It supports Plugins, which are community-contributed modules that provide a basic bridge from HomeKit to various 3rd-party APIs provided by manufacturers of "smart home" devices.

What is **[Hyperion](https://github.com/hyperion-project/hyperion)**?

Hyperion is an opensource 'AmbiLight' implementation supported by many devices.

### Environment variables

- **CUSTOMPLUGINS** : Homebridge plugins installed at startup *(default : empty)*

### Volumes
* /config : Place your config here

### Ports
* 51826
