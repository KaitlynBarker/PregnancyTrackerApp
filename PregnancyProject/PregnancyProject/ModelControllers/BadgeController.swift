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
    
    func fetchBadges() {
        
    }
    
    func fetchBadgesByChild() {
        
    }
    
    func fetchBadgesByPregnancy() {
        
    }
    
    // MARK: - Update
    
    func updateBadge() {
        
    }
    
    // MARK: - Delete - Im not sure if we need this.
    
}
