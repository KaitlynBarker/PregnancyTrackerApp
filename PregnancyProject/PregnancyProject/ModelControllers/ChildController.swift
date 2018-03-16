//
//  ChildController.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/22/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class ChildController {
    static let shared = ChildController()
    
    private let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    var currentChild: Child?
    
    var children: [Child] = [] {
        didSet {
            DispatchQueue.main.async {
                // notification
            }
        }
    }
    
    // MARK: - Create
    
    func createChild(name: String, dateOfBirth: Date = Date(), age: Int, gender: String, image: UIImage?, completion: @escaping (Error?) -> Void /*either image array, or just the image that i have in create entry func*/) {
        
        guard let image = image, let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        
        let child = Child(name: name, dateOfBirth: dateOfBirth, age: age, gender: gender, photoData: data)
        let childRecord = CKRecord(child: child)
        
        cloudKitManager.saveRecord(childRecord) { (_, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error saving record. \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
            self.children.append(child)
        }
    }
    
    // MARK: - Fetch
    
    func fetchChildren(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let sortDescriptors = [NSSortDescriptor(key: Child.dateOfBirthKey, ascending: true)]
        
        cloudKitManager.fetchRecordsWith(type: Child.recordType, sortDescriptors: sortDescriptors) { (records, error) in
            
            if let error = error {
                NSLog("error found. \(#file) \(#function) \n\(error.localizedDescription)")
            }
            
            guard let childrenRecords = records else { completion(false); return }
            let children = childrenRecords.flatMap { Child(ckRecord: $0) }
            
            self.children = children
            completion(true)
        }
    }
    
    // MARK: - Update
    
    func updateChildInfo(child: Child?, image: UIImage?, name: String, dateOfBirth: Date = Date(), age: Int, gender: String, completion: @escaping ((_ success: Bool) -> Void) = { _ in }) {
        
        guard let child = child, let image = image else { return }
        let data = UIImageJPEGRepresentation(image, 0.8)
        
        child.name = name
        child.dateOfBirth = dateOfBirth
        child.age = age
        child.gender = gender
        child.photoData = data
        
        let childRecord = CKRecord(child: child)
        
        cloudKitManager.modify(records: [childRecord], perRecordCompletion: { (_, error) in
            if let error = error {
                NSLog("Error updating child info. \(#file) \(#function) \n\(error.localizedDescription)")
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
                NSLog("Error deleting child record. \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
        }
    }
    
    func deleteChild(child: Child) {
        let childRecord = CKRecord(child: child)
        cloudKitManager.deleteOperation(childRecord) {
            guard let index = self.children.index(of: child) else { return }
            self.children.remove(at: index)
        }
    }
}
