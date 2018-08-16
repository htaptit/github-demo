//
//  NetworkControl.swift
//  WorldWide
//
//  Created by Hoang Trong Anh on 3/12/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//
import Foundation
import Moya

enum GoogleApi {
    case top_headlines(country: String?, page: Int?, page_size: Int?)
    case everything(query: String?, sources: [NewsSource]?, domains: [NewsSource]?, from: String?, to: String?, language: String?, sortBy: String?, pageSize: Int?, page: Int?)
}

extension GoogleApi : TargetType {
    var baseURL: URL  { return URL(string: "https://newsapi.org")! }
    
    var path: String {
        switch self {
        case .top_headlines:
            return "/v2/top-headlines"
        case .everything:
            return "/v2/everything"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .top_headlines,
             .everything :
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params = [String: Any]()
        switch self {
        case .top_headlines(let country, let page, let page_size):
            if let _ = country {
                params["country"] = country
            }
            
            if let _ = page {
                params["page"] = page!
            }
            
            if let _ = page_size {
                params["pageSize"] = page_size!
            }
            return params
            
        case .everything(let query, let sources, let domains, let from, let to, let language, let sortBy, let pageSize, let page) :
            if let _ = query { params["q"] = query! }
            if let _ = sources { params["sources"] = sources!.compactMap( { $0.string } ).joined(separator: ",") }
            if let _ = domains { params["domains"] = domains!.compactMap( { $0.shortDomain } ).joined(separator: ",") }
            if let _ = from { params["from"] = from! }
            if let _ = to { params["to"] = to! }
            if let _ = language { params["language"] = language! }
            if let _ = sortBy { params["sortBy"] = sortBy! }
            if let _ = pageSize { params["pageSize"] = pageSize! }
            if let _ = page { params["page"] = page! }
            return params
        }
    }
    
    var parameterEncoding:ParameterEncoding {
        return URLEncoding.default
    }

    var headers: [String : String]? {
        return ["X-Api-Key" : "2c297d7fb6b940ff9eb0e53651ad8997"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .top_headlines,
             .everything :
            if let _ = self.parameters {
                return .requestParameters(parameters: self.parameters!, encoding: parameterEncoding)
            }
            
            return .requestPlain
        }
    }
}

struct GoogleApiAdap {
    
    static let provider = MoyaProvider<GoogleApi>()
    
    static func request(target: GoogleApi, success successCallback: @escaping (Response) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    successCallback(response)
                } else {
                    let error = NSError(domain: target.baseURL.absoluteString, code: 0, userInfo: [NSLocalizedDescriptionKey: "### Code : \(response.statusCode), description: \(response.description) ###"])
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    }
}


