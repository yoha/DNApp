//
//  LocalDefaults.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 1/18/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

struct LocalDefaults {
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    static func saveToken(token: String) {
        userDefaults.setObject(token, forKey: "tokenKey")
    }
    
    static func loadToken() -> String? {
        return userDefaults.stringForKey("tokenKey")
    }
    
    static func deleteToken() {
        userDefaults.removeObjectForKey("tokenKey")
    }
}
