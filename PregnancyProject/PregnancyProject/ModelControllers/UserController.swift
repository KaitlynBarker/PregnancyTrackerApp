//
//  UserController.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/22/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    static let shared = UserController()
    
    private let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    var currentUser: User? {
        didSet {
            DispatchQueue.main.async {
                // notification?
            }
        }
    }
    
    // MARK: - Create
    
    func createUserWith(name: String, email: String, completion: @escaping (_ success: Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (userRecordID, error) in
            guard let userRecordID = userRecordID else { completion(false); return }
            let appleUserRef = CKReference(recordID: userRecordID, action: .deleteSelf)
            let user = User(name: name, email: email, appleUserRef: appleUserRef)
            let userRecord = CKRecord(user: user)
            
            self.cloudKitManager.saveRecord(userRecord) { (record, error) in
                defer { completion(true) }
                
                if let error = error {
                    NSLog("Error saving record \(#file) \(#function) \n\(error.localizedDescription)")
                    return
                }
                
                guard let record = record, let currentUser = User(ckRecord: record) else {
                    NSLog("Cannot create user record")
                    return
                }
                self.currentUser = currentUser
            }
        }
    }
    
    // MARK: - Retreive/Fetch
    
    func fetchCurrentUser(completion: @escaping ((_ success: Bool) -> Void) = { _ in }) {
        CKContainer.default().fetchUserRecordID { (userRecordID, error) in
            if let error = error {
                NSLog("Cannot fetch appleUser Record \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let userRecordID = userRecordID else {
                NSLog("Could not unwrap user recordID")
                completion(false)
                return
            }
            
            let userRef = CKReference(recordID: userRecordID, action: .deleteSelf)
            let predicate = NSPredicate(format: "appleUserRef == %@", userRef)
            
            self.cloudKitManager.fetchRecordsWithType(User.recordType, predicte: predicate, sortDescriptors: nil, recordFetchedBlock: nil) { (records, error) in
                
                guard let currentUserRecord = records?.first else {
                    completion(false)
                    return
                }
                
                let currentUser = User(ckRecord: currentUserRecord)
                self.currentUser = currentUser
                completion(true)
            }
        }
    }
    
    // MARK: - Update
    
    func updateUserInfo(name: String, email: String, _ completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = currentUser else {
            NSLog("Cannot unwrap current user")
            completion(false)
            return
        }
        
        currentUser.name = name
        currentUser.email = email
        
        let currentUserRecord = CKRecord(user: currentUser)
        
        let modificationOperation = CKModifyRecordsOperation(recordsToSave: [currentUserRecord], recordIDsToDelete: nil)
        
        modificationOperation.modifyRecordsCompletionBlock = { (_, _, error) in
            if let error = error {
                NSLog("Error modifying user info. \(#file) \(#function) \n\(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
            
            CKContainer.default().publicCloudDatabase.add(modificationOperation)
        }
    }
    
    // MARK: - Delete
    
    // so user can delete account if desired
    
    func deleteUser() {
        // FIXME: - fill this out
    }
    
}
