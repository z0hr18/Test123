//
//  TodoList+CoreDataProperties.swift
//  CoreDataApp
//
//  Created by Samxal Quliyev  on 18.10.23.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var title: String?

}

extension TodoList : Identifiable {

}
