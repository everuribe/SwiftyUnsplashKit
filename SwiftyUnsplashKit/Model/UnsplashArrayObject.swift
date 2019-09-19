//
//  JSONObjects.swift
//  GiphyTest
//
//  Created by Ever Uribe on 8/23/19.
//  Copyright © 2019 Ever Uribe. All rights reserved.
//

import Foundation

///Raw server response using Giphy API:
struct RawServerResponse: Decodable {
    
    var results: [Results]
    
    struct Results: Decodable {
        var user: User
        var urls: ImageUrl
    }
    
    struct User: Decodable {
        var name: String
        var links: UserProfileLink
    }
    
    struct UserProfileLink: Decodable {
        var html: String
    }
    
    struct ImageUrl: Decodable {
//        var small: String //Images of 400 px width
        var regular: String //Images of 1080 px width
    }
}

///Object decoding Giphy raw response into an array of GIF urls. 
struct UnsplashArrayObject: Decodable {
    var unsplashImagesInfo: [UnsplashImageInfo]
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponse(from: decoder)
        
        unsplashImagesInfo = []
        
        for result in rawResponse.results {
            let userName: String = result.user.name, userProfileLink: String = result.user.links.html, imageUrl: String = result.urls.regular
            
            let newObject: UnsplashImageInfo = UnsplashImageInfo(userName: userName, userProfileLink: userProfileLink, imageUrl: imageUrl)
            unsplashImagesInfo.append(newObject)
        }
    }
}

struct UnsplashImageInfo {
    var userName: String
    var userProfileLink: String
    var imageUrl: String
}
