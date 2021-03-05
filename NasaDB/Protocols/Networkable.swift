//
//  Networkable.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<NasaAPI> { get }
    func fetchOppurtunityRover(page: Int, completion: @escaping ([Photo]) -> () )
    func fetchCuriosityRover(page: Int, completion: @escaping ([Photo]) -> () )
    func fetchSpiritRover(page: Int, completion: @escaping ([Photo]) -> () )
    func opportunityRoverCameraSearch(camera: String, page: Int, completion: @escaping ([Photo]) -> () )
    func curiosityRoverCameraSearch(camera: String, page: Int, completion: @escaping ([Photo]) -> () )
    func spiritRoverCameraSearch(camera: String, page: Int, completion: @escaping ([Photo]) -> () )
}
