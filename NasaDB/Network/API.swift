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
    case opportunity
    case curiosity
    case spirit
    case opportunitySearch(camera: String)
    case curiositySearch(camera: String)
    case spiritSearch(camera: String)
}

fileprivate let APIKey = "LUL419Ui2W9PchaVhajYSPTsq3FSH5JF50AZNhl7"

extension NasaAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .opportunity:
            return "Opportunity/photos"
        case .curiosity:
            return "Curiosity/photos"
        case .spirit:
            return "Spirit/photos"
        case .opportunitySearch(_):
            return "Opportunity/photos"
        case .curiositySearch(_):
            return "Curiosity/photos"
        case .spiritSearch(_):
            return "Spirit/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .opportunity, .curiosity, .spirit, .opportunitySearch(_), .curiositySearch(_), .spiritSearch(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .opportunity, .curiosity, .spirit:
            return .requestParameters(parameters: ["api_key" : APIKey, "sol" : 1000], encoding: URLEncoding.queryString)
        case .opportunitySearch(camera: let camera), .curiositySearch(camera: let camera), .spiritSearch(camera: let camera):
            return .requestParameters(parameters: ["api_key" : APIKey, "sol" : 1000, "camera" : camera], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
