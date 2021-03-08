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
    case opportunity(page: Int)
    case curiosity(page: Int)
    case spirit(page: Int)
    case opportunitySearch(camera: String, page: Int)
    case curiositySearch(camera: String, page: Int)
    case spiritSearch(camera: String, page: Int)
}

fileprivate let APIKey = "LUL419Ui2W9PchaVhajYSPTsq3FSH5JF50AZNhl7"

extension NasaAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .opportunity(_):
            return "Opportunity/photos"
        case .curiosity(_):
            return "Curiosity/photos"
        case .spirit(_):
            return "Spirit/photos"
        case .opportunitySearch(_, _):
            return "Opportunity/photos"
        case .curiositySearch(_, _):
            return "Curiosity/photos"
        case .spiritSearch(_, _):
            return "Spirit/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .opportunity(_), .curiosity(_), .spirit(_), .opportunitySearch(_, _), .curiositySearch(_, _), .spiritSearch(_, _):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .curiosity(page: let page):
            return .requestParameters(parameters: ["api_key" : APIKey,
                                                   "sol" : 1000,
                                                   "page" : page], encoding: URLEncoding.queryString)
        case .opportunity(page: let page),
             .spirit(page: let page):
            return .requestParameters(parameters: ["api_key" : APIKey,
                                                   "sol" : 1,
                                                   "page" : page], encoding: URLEncoding.queryString)
            
            
        case .curiositySearch(camera: let camera, page: let page):
            return .requestParameters(parameters: ["api_key" : APIKey,
                                                   "sol" : 1000,
                                                   "camera" : camera,
                                                   "page" : page], encoding: URLEncoding.queryString)
        case .opportunitySearch(camera: let camera, page: let page),
             .spiritSearch(camera: let camera, page: let page):
            return .requestParameters(parameters: ["api_key" : APIKey,
                                                   "sol" : 1,
                                                   "camera" : camera,
                                                   "page" : page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
