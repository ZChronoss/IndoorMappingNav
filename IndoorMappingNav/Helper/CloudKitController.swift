//
//  CloudKitController.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 08/10/24.
//

import Foundation
import CloudKit

class CloudKitController: ObservableObject {
    private let database = CKContainer.init(identifier: "iCloud.apq.IndoorMappingNav").publicCloudDatabase
    
    func fetchStores() async throws -> [Store] {
        let predicate = NSPredicate(value: true) // Fetch all stores
        //        let sort = NSSortDescriptor(key: "Id", ascending: true)
        let query = CKQuery(recordType: "Store", predicate: predicate)
        //        query.sortDescriptors = [sort]
        
        let result = try await database.records(matching: query, resultsLimit: 10)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        //        do {
        //            let (storeResults, _) = try await database.records(matching: query)
        //
        //            return storeResults.compactMap { _, result in
        //                let newStore = try? Store(record: result.get())
        //                store?.append(newStore!)
        //                return newStore
        //            }
        //        } catch {
        //            print("Error fetching store records from CloudKit: \(error.localizedDescription)")
        //        }
        
        return records.compactMap(Store.init)
    }
    
    // Fetch a Mall by ID (from a store reference)
    func fetchMall(withID mallID: CKRecord.ID, completion: @escaping (Mall?) -> Void) {
        database.fetch(withRecordID: mallID) { record, error in
            if let error = error {
                print("Error fetching mall: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let record = record else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(Mall(record: record))
            }
        }
    }
    
    func fetchStoreByCategory(category: String) async throws -> [Store] {
        guard let categoryID = mapCategoryToID(category: category) else {
            print("Invalid category name: \(category)")
            return []
        }
        
        let predicate = NSPredicate(format: "%K == %d", "Category", categoryID) // Query based on category ID
        let query = CKQuery(recordType: "Store", predicate: predicate)

        let result = try await database.records(matching: query, resultsLimit: 10)
        let records = result.matchResults.compactMap { try? $0.1.get() }

        return records.compactMap(Store.init) // Convert CKRecords to Store models
    }
    
    private func mapCategoryToID(category: String) -> Int? {
        let categoryMap = [
            "Toilet": 1,
            "Food & Beverage": 2,
            "Shopping": 3,
            "Service": 4,
            "Health & Beauty": 5
        ]
        return categoryMap[category]
    }
    
    func fetchStoreByName(name: String) async throws -> Store {
        let predicate = NSPredicate(format: "%K == %@", "Name", name)
        
        let query = CKQuery(recordType: "Store", predicate: predicate)
        
        //        let operation = CKQueryOperation(query: query)
        //        operation.desiredKeys = ["Name", "Category", "Address", "Images", "Floor"]
        
        let result = try await database.records(matching: query, resultsLimit: 1)
        let record = result.matchResults.compactMap { _, result in
            try? result.get()
        }
        
        if let store = record.first {
            return Store(record: store)
        }else{
            return Store()
        }
    }
    // ini buat fix bug
}
