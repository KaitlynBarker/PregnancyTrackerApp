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
}
