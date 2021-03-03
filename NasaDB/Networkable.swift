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
    func fetchOppurtunityRover(completion: @escaping ([Photo]) -> () )
    func fetchCuriosityRover(completion: @escaping ([Photo]) -> () )
    func fetchSpiritRover(completion: @escaping ([Photo]) -> () )
}
