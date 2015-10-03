//
//  Queryable.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2015-06-17.
//  Copyright (c) 2015 Alecrim. All rights reserved.
//

import Foundation
import CoreData

public protocol Queryable: Enumerable {
    
    var predicate: NSPredicate? { get set }
    var sortDescriptors: [NSSortDescriptor]? { get set }
    
}

// MARK - ordering

extension Queryable {
    
    public func sortByAttribute<A: AttributeType>(attribute: A, ascending: Bool = true) -> Self {
        return self.sortByAttributeName(attribute.___name, ascending: ascending, options: attribute.___comparisonPredicateOptions)
    }

    public func sortByAttributeName(attributeName: String, ascending: Bool = true, options: NSComparisonPredicateOptions = NSComparisonPredicateOptions()) -> Self {
        let sortDescriptor: NSSortDescriptor
        
        if options.contains(.CaseInsensitivePredicateOption) && options.contains(.DiacriticInsensitivePredicateOption) {
            sortDescriptor = NSSortDescriptor(key: attributeName, ascending: ascending, selector: Selector("localizedCaseInsensitiveCompare:"))
        }
        else if options.contains(.CaseInsensitivePredicateOption) {
            sortDescriptor = NSSortDescriptor(key: attributeName, ascending: ascending, selector: Selector("caseInsensitiveCompare:"))
        }
        else if options.contains(.DiacriticInsensitivePredicateOption) {
            sortDescriptor = NSSortDescriptor(key: attributeName, ascending: ascending, selector: Selector("localizedCompare:"))
        }
        else {
            sortDescriptor = NSSortDescriptor(key: attributeName, ascending: ascending)
        }
        
        
        return self.sortUsingSortDescriptor(sortDescriptor)
    }

    public func sortUsingSortDescriptor(sortDescriptor: NSSortDescriptor) -> Self {
        var clone = self
        
        if clone.sortDescriptors != nil {
            clone.sortDescriptors!.append(sortDescriptor)
        }
        else {
            clone.sortDescriptors = [sortDescriptor]
        }
        
        return clone
    }

}

// MARK - filtering

extension Queryable {
    
    public func filterUsingPredicate(predicate: NSPredicate) -> Self {
        var clone = self
        
        if let existingPredicate = clone.predicate {
            clone.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [existingPredicate, predicate])
        }
        else {
            clone.predicate = predicate
        }
        
        return clone
    }
    
}
