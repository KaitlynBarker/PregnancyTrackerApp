//
//  BadgeController.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/22/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit

class BadgeController {
    static let shared = BadgeController()
    
    private let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    // current badge?
    
    var badges: [Badge] = [] {
        didSet {
            DispatchQueue.main.async {
                //notification info
            }
        }
    }
    
    // MARK: - Create
    
    func createBadge(name: String, passedOff: Bool, completion: @escaping (Error?) -> Void) {
        let badge = Badge(name: name, passedOff: passedOff)
        let badgeRecord = CKRecord(badge: badge)
        
        cloudKitManager.saveRecord(badgeRecord) { (_, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error saving record. \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
            self.badges.append(badge)
        }
    }
    
    // MARK: - Fetch
    
    func fetchBadges(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let sortDescriptors = [NSSortDescriptor(key: Badge.passedOffKey, ascending: true)]
        
        cloudKitManager.fetchRecordsWith(type: Badge.recordType, sortDescriptors: sortDescriptors) { (records, error) in
            
            if let error = error {
                NSLog("error found fetching badges. \(#file) \(#function) \n\(error.localizedDescription)")
            }
            
            guard let badgeRecords = records else { completion(false); return }
            let badges = badgeRecords.flatMap { Badge(ckRecord: $0) }
            
            self.badges = badges
            completion(true)
        }
    }
    
    func fetchBadgesByChild(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let sortDescriptors = [NSSortDescriptor(key: Badge.passedOffKey, ascending: true)]
        
        guard let childRefID = ChildController.shared.currentChild?.ckRecordID else { completion(false); return }
        
        let childRef = CKReference(recordID: childRefID, action: .none)
        let predicate = NSPredicate(format: "child == %@", childRef)
        
        cloudKitManager.fetchRecordsWithType(Badge.recordType, predicte: predicate, sortDescriptors: sortDescriptors, recordFetchedBlock: nil) { (records, error) in
            
            if let error = error {
                NSLog("Error found. \(#file) \(#function) \n\(error.localizedDescription)")
            }
            
            guard let childBadges = records else { completion(false); return }
            let badges = childBadges.flatMap { Badge(ckRecord: $0) }
            
            self.badges = badges
            completion(true)
        }
    }
    
    func fetchBadgesByPregnancy(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let sortDescriptors = [NSSortDescriptor(key: Badge.passedOffKey, ascending: true)]
        
        guard let pregnancyRefID = PregnancyController.shared.currentPregnancy?.ckRecordID else { completion(false); return }
        
        let pregnancyRef = CKReference(recordID: pregnancyRefID, action: .none)
        let predicate = NSPredicate(format: "pregnancy == %@", pregnancyRef)
        
        cloudKitManager.fetchRecordsWithType(Badge.recordType, predicte: predicate, sortDescriptors: sortDescriptors, recordFetchedBlock: nil) { (records, error) in
            
            if let error = error {
                NSLog("error found. \(#file) \(#function) \n\(error.localizedDescription)")
            }
            
            guard let pregnancyBadges = records else { completion(false); return }
            let badges = pregnancyBadges.flatMap { Badge(ckRecord: $0) }
            
            self.badges = badges
            completion(true)
        }
    }
    
    // MARK: - Update
    
    func updateBadge(badge: Badge?, name: String, passedOff: Bool, completion: @escaping ((_ success: Bool) -> Void) = { _ in }) {
        
        guard let badge = badge else { return }
        
        badge.name = name
        badge.passedOff = passedOff
        
        let badgeRecord = CKRecord(badge: badge)
        
        cloudKitManager.modify(records: [badgeRecord], perRecordCompletion: { (_, error) in
            if let error = error {
                NSLog("Error updating badge. \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
        }) { (records, error) in
            let success = records != nil
            completion(success)
        }
    }
    
    // MARK: - Delete - Im not sure if we need this.
    
}
