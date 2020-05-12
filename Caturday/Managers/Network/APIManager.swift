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
    func sendRequest(urlString: String, method: HTTPMethod, success: ((Data)->Void)?, failure: ((Error)->Void)?) {
        let session = URLSession.shared
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(apikey, forHTTPHeaderField: "x-api-key")
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                print("Success!")
                success?(data)
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
    func getImage(urlString: String, element: UIImageView) {
        sendRequest(urlString: urlString, method: .get, success: { (data) in
            DispatchQueue.main.async {
                element.image = UIImage(data: data)
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getBreeds(success: ((Data)->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + URLs.Breeds
        
        sendRequest(urlString: url, method: .get, success: { (data) in
            success?(data)
        }, failure: { (error) in
            failure?(error.localizedDescription)
        })
    }
}
