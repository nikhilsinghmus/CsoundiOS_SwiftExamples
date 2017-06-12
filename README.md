# Csound for iOS: Swift Examples
A Swift translation of the original Objective-C Csound iOS examples by Steven Yi and Victor Lazzarini.

This project is a Swift adaption of the Csound for iOS Examples project as of version 6.09. The current (Objective-C based) Csound-iOS manual is a good beginning reference for this project as well, and I'm planning to add some additional documentation for all of the things that are specific to the Swift version, or that have been modified for style or efficiency.

## Links

A current version of the Csound for iOS API, Objective-C Examples, and manual can be downloaded from [this page.](http://csound.github.io/download.html)

The main Csound repository is located [here.](https://github.com/csound/csound)

## Contributing

Contributions are welcome.

## Notes

There's a minor modification to the API itself in this project: Apple recommends that not more than one instance of CMMotionManager be used in an app, and as such I've exposed CsoundMotion's instance so as to be able to get a reference to it.