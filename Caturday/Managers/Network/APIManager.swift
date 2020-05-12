//
//  APIManager.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import WebKit

/*
 I'm going to use this singleton instance to perform network requests across the app
 */

class APIManager {
    // we won't need .post requests in this app, but this makes the HTTP methods usage in URLSession more explicit
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    // usually I hide it somewhere else, e.g. in Keychain
    var apikey: String {
        return "04b2b673-2732-4f20-b65e-39163f0f7ea0"
    }
        
    // hiding the initializer and initializing the "shared" property for singleton
    static let shared = APIManager()
    private init() {}
    
    // common wrapper for all upcoming network requests
    func sendRequest(urlString: String, page: Int?, limit: Int?, method: HTTPMethod, success: ((Data, Int)->Void)?, failure: ((Error)->Void)?) {
        let session = URLSession.shared
        
        var finalURLString = urlString
        
        if let page = page {
            finalURLString += "?page=\(page)"
        }
        
        if page != nil && limit != nil {
            guard let limit = limit else {return}
            finalURLString += "&limit=\(limit)"
        }
        
        if page == nil && limit != nil {
            guard let limit = limit else {return}
            finalURLString += "?limit=\(limit)"
        }
        
        guard let url = URL(string: finalURLString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(apikey, forHTTPHeaderField: "x-api-key")
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                guard let paginationCountHeader = response.allHeaderFields["pagination-count"] as? String else {return}
                guard let paginationCountHeaderInt = Int(paginationCountHeader) else {return}
                
                if let data = data {
                    print("[REQUEST] \(method.rawValue): \(finalURLString)")
                    print("200 - Success!")
                    success?(data, paginationCountHeaderInt)
                }
            }
            
            if let error = error {
                print("Error! \(error.localizedDescription)")
                failure?(error)
                return
            }
        }
        
        task.resume()
    }
}

extension APIManager {
    func getImage(urlString: String, success: ((UIImage)->Void)?) {
        sendRequest(urlString: urlString, page: nil, limit: 1, method: .get, success: { (data, paginationCount) in
            success?(UIImage(data: data)!)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getImageURL(breedID: String, success: ((Data)->Void)?) {
        let url = URLs.Server + URLs.Images
        
        sendRequest(urlString: url, page: 0, limit: 1, method: .get, success: { (data, paginationCount) in
            success?(data)
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func getBreeds(limit: Int, success: ((Data, Int)->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + URLs.Breeds
        
        sendRequest(urlString: url, page: nil, limit: limit, method: .get, success: { (data, paginationCount) in
            success?(data, paginationCount)
        }, failure: { (error) in
            failure?(error.localizedDescription)
        })
    }
    
    func getMoreBreeds(page: Int, limit: Int, success: ((Data, Int)->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + URLs.Breeds
        
        sendRequest(urlString: url, page: page, limit: limit, method: .get, success: { (data, paginationCount) in
            success?(data, paginationCount)
        }, failure: { (error) in
            failure?(error.localizedDescription)
        })
    }
}
