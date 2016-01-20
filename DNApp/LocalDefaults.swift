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
    
    // MARK: - Token-related Methods
    
    static func saveToken(token: String) {
        userDefaults.setObject(token, forKey: "tokenKey")
    }
    
    static func loadToken() -> String? {
        return userDefaults.stringForKey("tokenKey")
    }
    
    static func deleteToken() {
        userDefaults.removeObjectForKey("tokenKey")
    }
    
    // MARK: - Upvoted-related Methods
    
    static func saveUpvotedStory(storyID: Int) {
        self.appendID(storyID, toKey: "upvotedStoriesKey")
    }
    
    static func saveUpvotedComment(commentID: Int) {
        self.appendID(commentID, toKey: "upvotedCommentsKey")
    }
    
    static func isStoryUpvoted(storyID: Int) -> Bool {
        return self.arrayForKey("upvotedStoriesKey", containsID: storyID)
    }
    
    static func isCommentUpvoted(commentID: Int) -> Bool {
        return self.arrayForKey("upvotedCommentsKey", containsID: commentID)
    }
    
    // MARK - Helper Methods
    
    private static func arrayForKey(key: String, containsID id: Int) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        return elements.contains(id)
    }
    
    private static func appendID(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if !elements.contains(id) {
            userDefaults.setObject(elements + [id], forKey: key)
        }
    }
}
