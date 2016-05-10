# at-do-cleanup

## Overview
This code is used to clean up duplicate `DigitalObjects` from Archivist's Toolkit databases.


## Status
#### IN DEVELOPMENT

## Overview

#### Proposed logic of the cleanup script is:
[from here](https://www.pivotaltracker.com/projects/1456278/stories/111327956)

If all of these statements are true about two digital objects (DO):
- have the same METS Identifier (e.g. RISM MC 1.ref121.1)
- have the same Title
- have the same unitdate
- were created and last modified by user 'dlts'
- have the same URI

Define the duplicate as the one that is both:
- is older
- is not linked to a Resource record

Then:
- delete the duplicate


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/at-do-cleanup.


## License

The code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
