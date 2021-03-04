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

fileprivate let APIKey = "LUL419Ui2W9PchaVhajYSPTsq3FSH5JF50AZNhl7"

extension NasaAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .Opportunity:
            return "Opportunity/latest_photos"
        case .Curiosity:
            return "Curiosity/latest_photos"
        case .Spirit:
            return "Spirit/latest_photos"
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
            return .requestParameters(parameters: ["api_key" : APIKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
