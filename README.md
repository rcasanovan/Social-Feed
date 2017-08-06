# Social-Feed
This is a sample to get Social Feed with Objective C / Swift 3 integration.

I decided to use Objective C / Swift 3 to show how to integrate both languages in the same project.

## Project Architecture 
![alt tag](https://github.com/rcasanovan/Social-Feed/blob/master/presentation/images/projectArchitecture.jpeg?raw=true)

## Design pattern
* Model-View-View-Model (MVVM)

## Screenshots
![alt tag](https://github.com/rcasanovan/Social-Feed/blob/master/presentation/images/01.png?raw=true)
![alt tag](https://github.com/rcasanovan/Social-Feed/blob/master/presentation/images/02.png?raw=true)
![alt tag](https://github.com/rcasanovan/Social-Feed/blob/master/presentation/images/03.png?raw=true)
![alt tag](https://github.com/rcasanovan/Social-Feed/blob/master/presentation/images/04.png?raw=true)
![alt tag](https://github.com/rcasanovan/Social-Feed/blob/master/presentation/images/05.png?raw=true)
![alt tag](https://github.com/rcasanovan/Social-Feed/blob/master/presentation/images/06.png?raw=true)
![alt tag](https://github.com/rcasanovan/Social-Feed/blob/master/presentation/images/07.png?raw=true)

## Future improvements

* Coredata integration: We can add core data to project in order to save locally all feed list so we can show it while the api call returns the update list. We can do this using Magical Record as wrapper -> https://github.com/magicalpanda/MagicalRecord.
* Loader integration: We can add SVProgressHUD pod or something like this in order to show a loader while the api call returns information

## Development tools

I used the following development tools:

* Xcode 8.3.3
* Cocoapods 1.2.0

## Programming languages

* Swift 3
* Objective C

## External libraries

* InstagramKit
* HanekeSwift -> 0.10 (using feature/swift-3 branch)
* AFNetworking -> 3.0
* TwitterKit

## Warnings in the project 

The warnings in the project are produced by the external libraries (TwitterKit and InstagramKit) because these libraries are not updated for Swift 3

## References

* [Model-View-View-Model design pattern](https://en.wikipedia.org/wiki/Model–view–viewmodel)

## Support && contact

### Email

You can contact me using my email: ricardo.casanova@outlook.com

### Twitter

Follow me [@rcasanovan](http://twitter.com/rcasanovan) on twitter.