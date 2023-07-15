# AppIntentsDemo

# Multiple-Predicates issue with AppIntents's EntityPropertyQuery

## video 
This video demos the `EntityPropertyQuery` (Find Intent) implemented with SwiftData, which lack of multiple-predicates filter feature.


https://github.com/frogcjn/AppIntentsDemo/assets/1777562/e29a085c-17ed-41dc-b034-5f544210e5be


Refer the `BookEntity.swift` code to alter SwiftData version and CoreData version implementation.
`./Booky/AppIntents/Values/BookEntity.swift`
```Swift
    // option 3: Property Entity Query
    // option 3-1: Property Entity Query - SwiftData version
    static var defaultQuery = PropertyEntityQuery_BookEntity_SwiftData() // !!!: SwiftData version: lack of multiple-predicates filter feature
    
    // option 3-2: Property Entity Query - CoreData version
    // static var defaultQuery = PropertyEntityQuery_BookEntity_CoreData() // !!!: CoreData version: OK with multiple-predicates filter feature
```

The two version implementation is in these two files:
* `./Booky/AppIntents/Intents/EntityQuery/EntityQuery_Property_CoreData.swift`
* `./Booky/AppIntents/Intents/EntityQuery/EntityQuery_Property_SwiftData.swift`

