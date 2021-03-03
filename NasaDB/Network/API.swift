//
//  API.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import Moya

enum NasaAPI {
    case Opportunity
    case Curiosity
    case Spirit
}

extension NasaAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .Opportunity:
            return "Opportunity/photos?sol=1000"
        case .Curiosity:
            return "Curiosity/photos?sol=1000"
        case .Spirit:
            return "Spirit/photos?sol=1000"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Opportunity, .Curiosity, .Spirit:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .Opportunity, .Curiosity, .Spirit:
            return .requestParameters(parameters: ["api_key" : "DEMO_KEY"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
