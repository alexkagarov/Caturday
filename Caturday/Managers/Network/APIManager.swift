//
//  APIManager.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import WebKit
import UIKit

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
    func sendRequest(urlString: String, page: Int?, limit: Int?, query: String?, method: HTTPMethod, success: ((Data, Int)->Void)?, failure: ((Error)->Void)?) {
        let session = URLSession.shared
        
        var finalURLString = urlString
        
        if let page = page {
            finalURLString += "?page=\(page)"
        }
        
        if page != nil && limit != nil {
            guard let limit = limit else {return}
            finalURLString += "&limit=\(limit)"
            
            if let query = query {
                finalURLString += "&breed_id=\(query)"
            }
        }
        
        if page == nil && limit != nil {
            guard let limit = limit else {return}
            finalURLString += "?limit=\(limit)"
        }
        
        guard let url = URL(string: finalURLString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(apikey, forHTTPHeaderField: "x-api-key")
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                guard let paginationCountHeader = response.allHeaderFields["pagination-count"] as? String else { return }
                guard let paginationCountHeaderInt = Int(paginationCountHeader) else { return }
                
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
        }.resume()
    }
    
    // the catapi offers sending requests for images in different ways, this function receives image JSON object as a response
    func sendRequestForImage(urlString: String, success: ((Data)->Void)?, failure: ((Error)->Void)?) {
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.setValue(apikey, forHTTPHeaderField: "x-api-key")
        
        let session = URLSession.shared
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                if let data = data {
                    print("[IMAGE REQUEST]: \(urlString)")
                    print("200 - Success!")
                    success?(data)
                }
            }
            
            if let error = error {
                print("Error! \(error.localizedDescription)")
                failure?(error)
                return
            }
        }.resume()
    }
    
    // the catapi offers sending requests for images in different ways, this function receives direct image as a response. BUT only one image, so it is not suitable for loading array of images
    func sendRequestForSingleBreedImage(urlString: String, breedID: String, success: ((UIImage)->Void)?, failure: ((Error)->Void)?) {
        let session = URLSession.shared
        
        let finalURLString = urlString + "?size=med&mime_types=jpg&format=src&breed_id=\(breedID)"
        
        guard let url = URL(string: finalURLString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.setValue(apikey, forHTTPHeaderField: "x-api-key")
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                if let data = data {
                    print("[IMAGE REQUEST]: \(finalURLString)")
                    print("200 - Success!")
                    if let image = UIImage(data: data) {
                        guard let compressedDataImage = image.jpegData(compressionQuality: 0.3) else {return}
                        guard let compressedImage = UIImage(data: compressedDataImage) else { return }
                        success?(compressedImage)
                    }
                }
            }
            
            if let error = error {
                print("Error! \(error.localizedDescription)")
                failure?(error)
                return
            }
        }.resume()
    }
}

// MARK: - Network functionality wrappers
// MARK: Functions that return batches of elements, suitable for requests with pagination
extension APIManager {
    func getItems(type: String, limit: Int, success: ((Data, Int)->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + type
        
        sendRequest(urlString: url, page: nil, limit: limit, query: nil, method: .get, success: { (data, paginationCount) in
            success?(data, paginationCount)
        }, failure: { (error) in
            failure?(error.localizedDescription)
        })
    }
    
    func getMoreItems(type: String, page: Int, limit: Int, success: ((Data, Int)->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + type
        
        sendRequest(urlString: url, page: page, limit: limit, query: nil, method: .get, success: { (data, paginationCount) in
            success?(data, paginationCount)
        }, failure: { (error) in
            failure?(error.localizedDescription)
        })
    }
}

// MARK: Images related functions. First two are request(query)->url(s)->image and the third one is request(query)->image(single image for one query request)
extension APIManager {
    func getImage(urlString: String, success: ((UIImage)->Void)?) {
        sendRequestForImage(urlString: urlString, success: { (data) in
            guard let image = UIImage(data: data) else { return }
            guard let compressedImageData = image.jpegData(compressionQuality: 0.3) else { return }
            guard let compressedImage = UIImage(data: compressedImageData) else { return }
            
            success?(compressedImage)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getImageURL(breedID: String, success: ((Data)->Void)?) {
        let url = URLs.Server + URLs.Images
        
        sendRequest(urlString: url, page: 0, limit: 1, query: breedID, method: .get, success: { (data, paginationCount) in
            success?(data)
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func getSingleBreedImage(breedID: String, success: ((UIImage)->Void)?) {
        let url = URLs.Server + URLs.Images
        
        sendRequestForSingleBreedImage(urlString: url, breedID: breedID, success: { (image) in
            success?(image)
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
}
