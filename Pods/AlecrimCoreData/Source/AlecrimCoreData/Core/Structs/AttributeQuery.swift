//
//  AttributeQuery.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2015-04-11.
//  Copyright (c) 2015 Alecrim. All rights reserved.
//

import Foundation
import CoreData

public struct AttributeQuery<T>: AttributeQueryType {
    
    public typealias Item = T
    
    public let dataContext: NSManagedObjectContext
    public let entityDescription: NSEntityDescription
    
    public var offset: Int = 0
    public var limit: Int = 0
    public var batchSize: Int = DataContextOptions.defaultBatchSize
    
    public var predicate: NSPredicate? = nil
    public var sortDescriptors: [NSSortDescriptor]? = nil
    
    public var returnsDistinctResults = false
    public var propertiesToFetch = [String]()
    
    private init(dataContext: NSManagedObjectContext, entityDescription: NSEntityDescription, offset: Int, limit: Int, batchSize: Int, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) {
        self.dataContext = dataContext
        self.entityDescription = entityDescription
        
        self.offset = offset
        self.limit = limit
        self.batchSize = batchSize
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }

}

// MARK: - Table extensions

extension Table {
    
    // one attribute
    public func select<P, A: AttributeType where A.ValueType == P>(@noescape closure: (Item.Type) -> A) -> AttributeQuery<P> {
        var attributeQuery = AttributeQuery<P>(
            dataContext: self.dataContext,
            entityDescription: self.entityDescription,
            offset: self.offset,
            limit: self.limit,
            batchSize: self.batchSize,
            predicate: self.predicate,
            sortDescriptors: self.sortDescriptors
        )
        
        attributeQuery.propertiesToFetch.append(closure(Item.self).___name)
        
        return attributeQuery
    }

    // more than one attribute
    public func select(propertiesToFetch: [String]) -> AttributeQuery<NSDictionary> {
        var attributeQuery = AttributeQuery<NSDictionary>(
            dataContext: self.dataContext,
            entityDescription: self.entityDescription,
            offset: self.offset,
            limit: self.limit,
            batchSize: self.batchSize,
            predicate: self.predicate,
            sortDescriptors: self.sortDescriptors
        )
        
        attributeQuery.propertiesToFetch = propertiesToFetch
        
        return attributeQuery
    }

    // TODO: this requires the `toArray` method of `AttributeQuery` to handle tuples
    
//    public func select<
//        P0, P1,
//        A0: AttributeType, A1: AttributeType
//        where
//        A0.ValueType == P0,
//        A1.ValueType == P1
//        >(@noescape closure: (Self.Item.Type) -> (A0, A1)) -> AttributeQuery<(P0, P1)> {
//            var attributeQuery = AttributeQuery<(P0, P1)>(
//                dataContext: self.dataContext,
//                entityDescription: self.entityDescription,
//                offset: self.offset,
//                limit: self.limit,
//                batchSize: self.batchSize,
//                predicate: self.predicate,
//                sortDescriptors: self.sortDescriptors
//            )
//            
//            let r = closure(Self.Item.self)
//            
//            attributeQuery.propertiesToFetch.append(r.0.___name)
//            attributeQuery.propertiesToFetch.append(r.1.___name)
//            
//            return attributeQuery
//    }
//    
//    public func select<
//        P0, P1, P2,
//        A0: AttributeType, A1: AttributeType, A2: AttributeType
//        where
//        A0.ValueType == P0,
//        A1.ValueType == P1,
//        A2.ValueType == P2
//        >(@noescape closure: (Self.Item.Type) -> (A0, A1, A2)) -> AttributeQuery<(P0, P1, P2)> {
//            var attributeQuery = AttributeQuery<(P0, P1, P2)>(
//                dataContext: self.dataContext,
//                entityDescription: self.entityDescription,
//                offset: self.offset,
//                limit: self.limit,
//                batchSize: self.batchSize,
//                predicate: self.predicate,
//                sortDescriptors:
//                self.sortDescriptors
//            )
//            
//            let r = closure(Self.Item.self)
//            
//            attributeQuery.propertiesToFetch.append(r.0.___name)
//            attributeQuery.propertiesToFetch.append(r.1.___name)
//            attributeQuery.propertiesToFetch.append(r.2.___name)
//            
//            return attributeQuery
//    }
//    
//    // TODO: OK, you got the idea. We have to have the same number of `select:` method overloads as the number of properties we want to select
    
}
