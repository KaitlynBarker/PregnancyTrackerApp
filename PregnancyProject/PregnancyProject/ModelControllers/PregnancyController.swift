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
    
    // MARK: - Create
    
    // MARK: - Fetch
    
    // MARK: - Update
    
    // MARK: - Delete
    
    
}
