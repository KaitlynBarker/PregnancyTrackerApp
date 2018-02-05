//
//  EntryController.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/22/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class EntryController {
    static let shared = EntryController()
    
    private let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    var entries: [Entry] = [] {
        didSet {
            DispatchQueue.main.async {
                // notification info
            }
        }
    }
    
    // MARK: - Create
    
    func createEntry(image: UIImage?, title: String, text: String, completion: @escaping (Error?) -> Void) {
        guard let image = image, let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        
        let entry = Entry(photoData: data, title: title, text: text)
        
        let entryRecord = CKRecord(entry: entry)
        
        cloudKitManager.saveRecord(entryRecord) { (_, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error saving record. \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
            self.entries.append(entry)
        }
    }
    
    // MARK: - Retreive/Fetch
    
    func fetchEntriesByChild(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let sortDescriptors = [NSSortDescriptor(key: Entry.timestampKey, ascending: true)]
        
        guard let childRefID = ChildController.shared.currentChild?.ckRecordID else { completion(false); return }
        
        let childRef = CKReference(recordID: childRefID, action: .none)
        
        let predicate = NSPredicate(format: "child == %@", childRef)
        
        cloudKitManager.fetchRecordsWithType(Entry.recordType, predicte: predicate, sortDescriptors: sortDescriptors, recordFetchedBlock: nil) { (records, error) in
            
            if let error = error {
                NSLog("error found. \(#file) \(#function) \n\(error.localizedDescription)")
            }
            
            guard let childEntries = records else { completion(false); return }
            let entries = childEntries.flatMap { Entry(ckRecord: $0) }
            
            self.entries = entries
            completion(true)
        }
        
    }
    
    func fetchEntriesByPregnancy(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let sortDescriptors = [NSSortDescriptor(key: Entry.timestampKey, ascending: true)]
        
        guard let pregnancyRefID = PregnancyController.shared.currentPregnancy?.ckRecordID else { completion(false); return }
        
        let pregnancyRef = CKReference(recordID: pregnancyRefID, action: .none)
        let predicate = NSPredicate(format: "pregnancy == %@", pregnancyRef)
        
        cloudKitManager.fetchRecordsWithType(Entry.recordType, predicte: predicate, sortDescriptors: sortDescriptors, recordFetchedBlock: nil) { (records, error) in
            
            if let error = error {
                NSLog("Error found. \(#file) \(#function) \n\(error.localizedDescription)")
            }
            
            guard let pregnancyEntries = records else { completion(false); return }
            let entries = pregnancyEntries.flatMap { Entry(ckRecord: $0) }
            
            self.entries = entries
            completion(true)
        }
    }
    
    // MARK: - Update
    
    // MARK: - Delete
}

