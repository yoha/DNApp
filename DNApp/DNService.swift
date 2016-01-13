//
//  DNService.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 1/13/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import Alamofire

struct DNService {
    // Doc: https://github.com/metalabdesign/dn_api_v2
    
    // MARK: - Stored Properties
    
    private static let baseURL = "https://www.designernews.co"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"
    
    private enum ResourcePath: CustomStringConvertible {
        case Login
        case Stories
        case StoryID(storyID: Int)
        case StoryUpvote(storyID: Int)
        case StoryReply(storyID: Int)
        case CommentUpvote(commentID: Int)
        case CommentReply(commentID: Int)
        
        var description: String {
            switch self {
            case ResourcePath.Login:
                return "/oauth/token"
            case .Stories:
                return "/api/v1/stories"
            case .StoryID(let sID):
                return "/api/v1/stories/\(sID)"
            case .StoryUpvote(let sID):
                return "/api/v1/stories/\(sID)/upvote"
            case .StoryReply(let sID):
                return "/api/v1/stories/\(sID)/reply"
            case .CommentUpvote(let cID):
                return "/api/v1/comments/\(cID)/upvote"
            case .CommentReply(let cID):
                return "api/v1/comments/\(cID)/reply"
            }
        }
    }
    
    // MARK: - Local Methods
    
    static func getStoriesForSection(section: String, page: Int, responseInJSON:(JSON) -> ()) {
        let urlStringToAPI = self.baseURL + self.ResourcePath.Stories.description + "/" + section
        let parameters = [
            "page": String(page),
            "client_id": self.clientID
        ]
        
        Alamofire.request(Method.GET, urlStringToAPI, parameters: parameters).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            guard let validResultValueFromResponse = response.result.value else { return }
            let stories = JSON(validResultValueFromResponse ?? [])
            responseInJSON(stories)
        }
    }
}
