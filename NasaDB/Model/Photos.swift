//
//  Rover.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let id, sol: Int
    let camera: Camera
    let image: String
    let earthDate: String
    let rover: Rover
    

    enum CodingKeys: String, CodingKey {
        case id, sol, camera, rover, image = "img_src", earthDate = "earth_date"
    }
}

struct DataResults: Codable {
    let photos: [Photo]
    
    private enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
}



