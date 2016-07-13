# at-do-cleanup

## Overview
This code is used to clean up duplicate `DigitalObjects` from Archivist's Toolkit databases.


## Status
#### IN DEVELOPMENT

Please note:
the test suite assumes a certain database state that was available during development.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NYULibraries/at-do-cleanup.


## License

The code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## NOTES:
This code is pretty ugly at this point.

A design using `OpenStruct` was chosen based on initial requirements.

Later it was determined that more and more complex operations were required,
but there wasn't sufficient time to do a full-blown refactoring, therefore,
the abstractions in use are not as elegant as desired.

## N.B.:
Duplicate `DigitalObject`s have the `file_version_uri` method populated.
Authoritative `DigitalObject`s DO NOT.

