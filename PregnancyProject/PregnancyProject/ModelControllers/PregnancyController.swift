//
//  PregnancyController.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/22/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit

class PregnancyController {
    static let shared = PregnancyController()
    
    private let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    var currentPregnancy: Pregnancy?
    
    var pregnancies: [Pregnancy] = [] {
        didSet {
            DispatchQueue.main.async {
                // notification info
            }
        }
    }
    
    // MARK: - Create
    
    func createPregnancy(name: String, dueDate: Date = Date(), completion: @escaping (Error?) -> Void) {
        let pregnancy = Pregnancy(name: name, dueDate: dueDate)
        let pregnancyRecord = CKRecord(pregnancy: pregnancy)
        
        cloudKitManager.saveRecord(pregnancyRecord) { (_, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("error creating pregnancy \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
            self.pregnancies.append(pregnancy)
        }
    }
    
    // MARK: - Fetch
    
    func fetchPregnancies(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let sortDescriptors = [NSSortDescriptor(key: Pregnancy.dueDateKey, ascending: true)]
        
        cloudKitManager.fetchRecordsWith(type: Pregnancy.recordType, sortDescriptors: sortDescriptors) { (records, error) in
            
            if let error = error {
                NSLog("error fetching pregnancies. \(#file) \(#function) \n\(error.localizedDescription)")
            }
            
            guard let pregnancyRecords = records else { completion(false); return }
            let pregnancies = pregnancyRecords.flatMap { Pregnancy(ckRecord: $0) }
            
            self.pregnancies = pregnancies
            completion(true)
        }
    }
    
    // MARK: - Update
    
    func updatePregnancyInfo(pregnancy: Pregnancy?, name: String, dueDate: Date = Date(), completion: @escaping ((_ success: Bool) -> Void) = { _ in }) {
        
        guard let pregnancy = pregnancy else { return }
        
        pregnancy.name = name
        pregnancy.dueDate = dueDate
        
        let pregnancyRecord = CKRecord(pregnancy: pregnancy)
        
        cloudKitManager.modify(records: [pregnancyRecord], perRecordCompletion: { (_, error) in
            if let error = error {
                NSLog("Error updating pregnancy info. \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
        }) { (records, error) in
            let success = records != nil
            completion(success)
        }
    }
    
    // MARK: - Delete
    
    func deleteRecord(recordID: CKRecordID, completion: @escaping ((Error?) -> Void) = { _ in }) {
        cloudKitManager.deleteRecordWithID(recordID) { (ckRecordID, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("error deleting pregnancy record. \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
        }
    }
    
    func deletePregnancy(pregnancy: Pregnancy) {
        let pregnancyRecord = CKRecord(pregnancy: pregnancy)
        cloudKitManager.deleteOperation(pregnancyRecord) {
            guard let index = self.pregnancies.index(of: pregnancy) else { return }
            self.pregnancies.remove(at: index)
        }
    }
}
