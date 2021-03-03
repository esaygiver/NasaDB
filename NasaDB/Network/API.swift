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
    }
    
    var path: String {
        switch self {
        case .Opportunity:
            return "Opportunity"
        case .Curiosity:
            return "Curiosity"
        case .Spirit:
            return "Spirit"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Opportunity, .Curiosity, .Spirit:
            return .get
        }
    }
    
    var sampleData: Data {
        <#code#>
    }
    
    var task: Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}
