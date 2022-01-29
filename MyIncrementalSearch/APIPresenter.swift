//
//  APIPresenter.swift
//  PPCurrencyConversion
//
//  Created by Jeremy Lua on 22/1/22.
//  Copyright © 2022 Jeremy Lua. All rights reserved.
//


import UIKit

///This class manages API calls and store the data if necessary.
class APIPresenter: NSObject {
    
    //only one instance is required
    private static let LAST_API_CALL_KEY = "LastAPICall"
    private static let BASE_URL = "https://api.github.com/search/repositories?"
     static var lastAPICall = Date(timeIntervalSince1970: 0)
    func getUnitTestURL() -> URL? {
        return URL(string: "\(APIPresenter.BASE_URL)q=test")
    }
    
    func loadList(query: String, page: Int, success: @escaping (([Item]) -> Void), throttleFailure: @escaping ()->Void ) {
        print(APIPresenter.lastAPICall.timeIntervalSince1970)
        print(Date(timeIntervalSinceNow: 5).timeIntervalSince1970)
        if (Date().timeIntervalSince(APIPresenter.lastAPICall)) < 5 {
            throttleFailure()
            return
        }
        APIPresenter.lastAPICall = Date()
        
        var request = URLRequest(url: URL(string: "\(APIPresenter.BASE_URL)q=\(query)&page=\(page)")!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let _ = error {
                print("error: \(String(describing: error))")
                return
                
            }
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(RepositoryModel.self, from: data!)

                success(decodedResponse.items)
            } catch {
                print("decode error")
            }
        }).resume()
    }
}

