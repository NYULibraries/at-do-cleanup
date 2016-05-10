## NOTES:

## DUPLICATE RECORD CRITERIA:

The following must match between two records:
```
DigitalObjects.metsIdentifier
DigitalObjects.title
DigitalObjects.dateExpression
DigitalObjects.dateBegin
DigitalObjects.dateEnd
FileVersions.uri [via FK digitalObjectId]
```

The following must be true for both records:
```
DigitalObjects.createdBy     = 'dlts'
DigitalObjects.lastUpdatedBy = 'dlts'
```

The following must be true for the duplicate record:
```
DigitalObjects.archDescriptionInstancesId IS NULL
DigitalObjects.created     is earlier than other records that meet selection criteria
DigitalObjects.lastUpdated is earlier than other records that meet selection criteria
```

Candidate records may be selected using the following criteria:
```
DigitalObjects.createdBy                   = 'dlts'
DigitalObjects.lastUpdatedBy               = 'dlts'
DigitalObjects.archDescriptionInstancesId  IS NULL
```

## Proposed logic of the cleanup script is:

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

------------------------------------------------------------------------------

SELECT uri, digitalObjectId FROM FileVersions group by uri having count(*) >= 2;
SELECT digitalObjectId, title, createdBy , lastUpdatedBy, metsIdentifier, archDescriptionInstancesId FROM DigitalObjects WHERE archDescriptionInstancesId IS NULL and createdBy = 'dlts' AND lastUpdatedBy = 'dlts';

SELECT digitalObjectId, title, createdBy , lastUpdatedBy, metsIdentifier, archDescriptionInstancesId FROM DigitalObjects WHERE metsIdentifier in (select metsIdentifier from DigitalObjects where archDescriptionInstancesId IS NULL and createdBy = 'dlts' AND lastUpdatedBy = 'dlts') order by metsIdentifier;

# this query identifies the DUPES
SELECT digitalObjectId, title, metsIdentifier, dateExpression, dateBegin, dateEnd, created, lastUpdated, archDescriptionInstancesId FROM DigitalObjects WHERE archDescriptionInstancesId IS NULL and createdBy = 'dlts' AND lastUpdatedBy = 'dlts' and metsIdentifier <> '';

# this query selects the DUPES and CURRENT records for the DUPES
SELECT digitalObjectId, title, metsIdentifier, dateExpression, dateBegin, dateEnd, created, lastUpdated, archDescriptionInstancesId FROM DigitalObjects WHERE metsIdentifier in (select metsIdentifier from DigitalObjects where archDescriptionInstancesId IS NULL and createdBy = 'dlts' AND lastUpdatedBy = 'dlts' and metsIdentifier <> '') order by metsIdentifier ASC, lastUpdated DESC;

