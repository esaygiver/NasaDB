//
//  Rover.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Rover: Codable {
    
    let name, landingDate, launchDate, status: String

    enum CodingKeys: String, CodingKey {
        case name, status, landingDate = "landing_date", launchDate = "launch_date"
    }
}
