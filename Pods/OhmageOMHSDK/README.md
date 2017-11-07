# OhmageOMHSDK

[![CI Status](http://img.shields.io/travis/jdkizer9/OhmageOMHSDK.svg?style=flat)](https://travis-ci.org/jdkizer9/OhmageOMHSDK)
[![Version](https://img.shields.io/cocoapods/v/OhmageOMHSDK.svg?style=flat)](http://cocoapods.org/pods/OhmageOMHSDK)
[![License](https://img.shields.io/cocoapods/l/OhmageOMHSDK.svg?style=flat)](http://cocoapods.org/pods/OhmageOMHSDK)
[![Platform](https://img.shields.io/cocoapods/p/OhmageOMHSDK.svg?style=flat)](http://cocoapods.org/pods/OhmageOMHSDK)

OhmageOMHSDK is data uploader for [ohmage-OMH](https://github.com/smalldatalab/omh-dsu).

**This project is currently experimental and will be changing rapidly. You probably shouldn't use it yet!**

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The example also depends upon two plist files: 
  * OMHClient.plist, which contains the following:
    * OHMBaseURL - the URL for the OHM DSU endpoint
    * OHMClientID - the application's OAuth Client ID
    * OHMClientSecret - the application's OAuth Client Secret
  * Locations.plist, which is an array containing circular region descriptions
    * name - A label which will be sent to the server
    * lattitude - in degrees
    * longitude - in degrees
    * distance - in meters

Both .plist files need to be added to the Example/OhmageOMHSDK directory.

## Requirements

## Installation

OhmageOMHSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "OhmageOMHSDK"
```

## Author

James Kizer @ Cornell Tech Foundry

## License

OhmageOMHSDK is available under the Apache 2.0 license. See the LICENSE file for more info.
