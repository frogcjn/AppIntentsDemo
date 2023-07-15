//
//  CDBook.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import Foundation
import CoreData

@objc(CDBook)
public class CDBook: NSManagedObject {

}


extension CDBook {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDBook> {
        NSFetchRequest<CDBook>(entityName: "Book")
    }
    
    @NSManaged
    public var uuid: UUID

    @NSManaged
    public var title: String
    
    @NSManaged
    public var author: String
    
    @NSManaged
    public var imageData: Data?
    
    @NSManaged
    public var isRead: Bool
    
    @NSManaged
    public var datePublished: Date
}
