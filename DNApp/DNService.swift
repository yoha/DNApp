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
    private static let clientID = "06abf39aab6a3b4d0aac2da48e3a5d0ffff4bfdbe80a449f1dc3bf72aa9aa357"
    private static let clientSecret = "5e97fbca0270e378d123d32872950001ad17262807811bd2ab9f60c5c4c74686"
    
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
    
    // MARK: Get stories
    
    static func getStoriesForSection(section: String, page: Int, responseInJSON: (JSON) -> ()) {
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
    
    static func getStoryForID(storyID: Int, responseInJSON: (JSON) -> ()) {
        let urlStringToAPI = self.baseURL + self.ResourcePath.StoryID(storyID: storyID).description
        let parameters = [
            "client_id": self.clientID
        ]
        
        Alamofire.request(.GET, urlStringToAPI, parameters: parameters).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            guard let validResultValueFromResponse = response.result.value else { return }
            let story = JSON(validResultValueFromResponse ?? [])
            responseInJSON(story)
        }
    }
    
    // MARK: Login
    
    static func loginWithEmail(email: String, password: String, responseAsClosure: (token: String?) -> ()) {
        let urlStringToAPI = self.baseURL + self.ResourcePath.Login.description
        let loginParameters = [
            "grant_type": "password",
            "username": email,
            "password": password,
            "client_id": self.clientID,
            "client_secret": self.clientSecret
        ]
        
        Alamofire.request(.POST, urlStringToAPI, parameters: loginParameters).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            guard let validResultValueFromResponse = response.result.value else { return }
            let dataAsSwiftyJSON = JSON(validResultValueFromResponse)
            guard let validAccessToken = dataAsSwiftyJSON["access_token"].string else { print("no acccess token received"); return }
            responseAsClosure(token: validAccessToken)
        }
    }
    
    // MARK: Upvote story / comment
    
    static func upvoteStoryWithID(storyID: Int, token: String, responseAsClosure: (successful: Bool) -> ()) {
        let urlStringToAPI = self.baseURL + self.ResourcePath.StoryUpvote(storyID: storyID).description
        self.upVoteWithURLStringToAPI(urlStringToAPI, token: token, responseAsClosure: responseAsClosure)
    }
    
    static func upvoteCommentWithID(commentID: Int, token: String, responseAsClosure: (successful: Bool) -> ()) {
        let urlStringToAPI = self.baseURL + self.ResourcePath.CommentUpvote(commentID: commentID).description
        self.upVoteWithURLStringToAPI(urlStringToAPI, token: token, responseAsClosure: responseAsClosure)
    }
    
    private static func upVoteWithURLStringToAPI(urlStringToAPI: String, token: String, responseAsClosure: (successful: Bool) -> ()) {
        guard let validUrlFromAPI = NSURL(string: urlStringToAPI) else { return }
        let urlRequest = NSMutableURLRequest(URL: validUrlFromAPI)
        urlRequest.HTTPMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(urlRequest).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            guard let validURLResponse = response.response else { return }
            let successfulResponse = validURLResponse.statusCode == 200
            responseAsClosure(successful: successfulResponse)
        }
    }
    
    // MARK: Reply story / comment
    
    static func replyStoryWithID(storyID: Int, token: String, body: String, responseAsClosure: (successful: Bool) ->()) {
        let urlStringToAPI = self.baseURL + self.ResourcePath.StoryReply(storyID: storyID).description
        self.replyWithURLStringToAPI(urlStringToAPI, token: token, body: body, responseAsClosure: responseAsClosure)
    }
    
    static func replyCommentWithID(commentID: Int, token: String, body: String, responseAsClosure: (successful: Bool) -> ()) {
        let urlStringToAPI = self.baseURL + self.ResourcePath.CommentReply(commentID: commentID).description
        self.replyWithURLStringToAPI(urlStringToAPI, token: token, body: body, responseAsClosure: responseAsClosure)
    }
    
    private static func replyWithURLStringToAPI(urlStringToAPI: String, token: String, body: String, responseAsClosure: (successful: Bool) -> ()) {
        guard let validUrlFromAPI = NSURL(string: urlStringToAPI) else { return }
        let urlRequest = NSMutableURLRequest(URL: validUrlFromAPI)
        urlRequest.HTTPMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = "comment[body]=\(body)".dataUsingEncoding(NSUTF8StringEncoding)
        
        Alamofire.request(urlRequest).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            guard let validDataFromResponse = response.data else { return }
            let dataAsSwiftyJSON = JSON(validDataFromResponse)
            dataAsSwiftyJSON["comment"].string != nil ? responseAsClosure(successful: true) : responseAsClosure(successful: false)
        }
    }
}
