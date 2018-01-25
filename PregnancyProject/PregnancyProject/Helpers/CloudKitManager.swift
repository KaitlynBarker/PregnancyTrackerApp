//
//  CloudKitManager.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/19/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    // MARK: - Save
    
    func saveRecord(_ record: CKRecord, completion: @escaping (CKRecord?, Error?) -> Void) {
        publicDatabase.save(record, completionHandler: completion)
    }
    
    func saveRecords(_ records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        modify(records: records, perRecordCompletion: perRecordCompletion, completion: completion)
    }
    
    // MARK: - Fetch
    
    func fetchRecord(withID recordID: CKRecordID, completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        publicDatabase.fetch(withRecordID: recordID) { (ckRecord, error) in
            completion?(ckRecord, error)
        }
    }
    
    func fetchRecordsWithType(_ type: String, predicte: NSPredicate = NSPredicate(value: true), sortDescriptors: [NSSortDescriptor]? = nil, recordFetchedBlock: ((_ record: CKRecord) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        var fetchedRecords: [CKRecord] = []
        
        let query = CKQuery(recordType: type, predicate: predicte)
        query.sortDescriptors = sortDescriptors
        let queryOperation = CKQueryOperation(query: query)
        
        let perRecordBlock = { (fetchRecord: CKRecord) -> Void in
            fetchedRecords.append(fetchRecord)
            recordFetchedBlock?(fetchRecord)
        }
        
        queryOperation.recordFetchedBlock = perRecordBlock
        
        var queryCompletionBlock: (CKQueryCursor?, Error?) -> Void = { (_, _) in }
        
        queryCompletionBlock = { [weak self] (queryCursor: CKQueryCursor?, error: Error?) -> Void in
            if let queryCursor = queryCursor {
                let continuedQueryOperation = CKQueryOperation(cursor: queryCursor)
                continuedQueryOperation.recordFetchedBlock = perRecordBlock
                continuedQueryOperation.queryCompletionBlock = queryCompletionBlock
                
                self?.publicDatabase.add(continuedQueryOperation)
            } else {
                completion?(fetchedRecords, error)
            }
        }
        
        queryOperation.queryCompletionBlock = queryCompletionBlock
        self.publicDatabase.add(queryOperation)
    }
    
    func fetchRecordsWith(type: String, sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping ((_ records: [CKRecord]?, _ error: Error?) -> Void)) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: type, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        publicDatabase.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    // MARK: - Update/Modify
    
    func modify(records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.perRecordCompletionBlock = perRecordCompletion
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            completion?(records, error)
        }
        
        publicDatabase.add(operation)
    }
    
    // MARK: - Delete
    
    func deleteRecordWithID(_ recordID: CKRecordID, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        
        publicDatabase.delete(withRecordID: recordID) { (recordID, error) in
            completion?(recordID, error)
        }
    }
    
    func deleteRecordsWithID(_ recordIDs: [CKRecordID], completion: ((_ records: [CKRecord]?, _ recordIDs: [CKRecordID]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
        operation.savePolicy = .ifServerRecordUnchanged
        operation.modifyRecordsCompletionBlock = completion
        
        publicDatabase.add(operation)
    }
    
    func deleteOperation(_ record: CKRecord, completion: @escaping () -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [record.recordID])
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        publicDatabase.add(operation)
        completion()
    }
}
