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
//        let sortDescriptors = [NSSortDescriptor(key: Entry.timestampKey, ascending: true)]
        
        
    }
    
    func fetchEntriesByPregnancy(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
//        let sortDescriptors = [NSSortDescriptor(key: Entry.timestampKey, ascending: true)]
    }
    
    // MARK: - Update
    
    // MARK: - Delete
}

