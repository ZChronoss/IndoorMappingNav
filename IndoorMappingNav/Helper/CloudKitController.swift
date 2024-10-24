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
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Id", "Name", "Category", "Address", "Images", "Floor", "MallId"]
        
        let result = try await database.records(matching: query)
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
    
    // ini buat fix bug
}
