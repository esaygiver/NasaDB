//
//  Camera.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Camera: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
