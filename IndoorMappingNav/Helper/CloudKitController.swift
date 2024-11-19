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
    
    
    // TODO: Kita harus ubah tiap mallId di database jadi disesuain sama recordName tabel Mall
    // Buat sekarang kita agak cheat pake cara ini, tapi kalo udah pake admin keknya harus diubah, kita coba aja dlu
    func fetchStores() async throws -> [Store] {
        let predicate = NSPredicate(format: "MallId == %@", CKRecord.ID(recordName: "1")) // Fetch all stores
        //        let sort = NSSortDescriptor(key: "Id", ascending: true)
        let query = CKQuery(recordType: "Store", predicate: predicate)
        
        let wantedField = ["Name", "Category", "Address", "Images", "Floor", "Subcategory", "MallId"]
        
        let result = try await database.records(matching: query, desiredKeys: wantedField)
        
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        let stores = records.compactMap(Store.init)
        
        return stores
    }
    
    
    func fetchStoreByName(name: String) async throws -> Store {
        let predicate = NSPredicate(format: "Name == %@", name)
        
        let query = CKQuery(recordType: "Store", predicate: predicate)
        
        let result = try await database.records(matching: query, resultsLimit: 1)
        let record = result.matchResults.compactMap { _, result in
            try? result.get()
        }
        
        if let store = record.first {
            return Store(record: store)
        } else{
            return Store()
        }
    }
    
    func fetchStoreBeginsWith(_ key: String) async throws -> [Store] {
        let predicate = NSPredicate(format: "Name BEGINSWITH %@", key)
        let query = CKQuery(recordType: "Store", predicate: predicate)
        
        let wantedField = ["Name", "Category", "Floor"]
        
        let result = try await database.records(matching: query, desiredKeys: wantedField, resultsLimit: 10)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
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
}


extension CloudKitController {
    /// DEBUGGING
    /// I have to do a small update on a value in the record to fix the database.
    /// This will enable the ability to query with strings
    ///
    /// MARK: Done btw
    /// NOTE: DONT DELETE FIXDATABASE
    func fixDatabase() async throws -> Void{
        let predicate = NSPredicate(format: "MallId != %@ AND MallId != %@", CKRecord.ID(recordName: "1"), CKRecord.ID(recordName: "-1")) // Fetch all stores
        let query = CKQuery(recordType: "Store", predicate: predicate)
        
        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        for record in records {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let someDateTime = formatter.date(from: "2024/11/17")
            
            let date = record.modificationDate
            
            if date?.compare(someDateTime!) == .orderedAscending {
                var name = record["Name"] as? String
                name?.append(" fix")
                record.setValue(name, forKey: "Name")
                try await database.save(record)
            }
        }
    }
    
    func fixDatabase2() async throws -> Void{
            let predicate = NSPredicate(format: "MallId == %@", CKRecord.ID(recordName: "1")) // Fetch all stores
            let query = CKQuery(recordType: "Store", predicate: predicate)
            
            let result = try await database.records(matching: query)
            let records = result.matchResults.compactMap { try? $0.1.get() }
            
            for record in records {
                if var name = record["Name"] as? String {
                    if name.hasSuffix(" fix") {
                        name.removeLast(4)
                        record.setValue(name, forKey: "Name")
                        try await database.save(record)
                    }
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
}

