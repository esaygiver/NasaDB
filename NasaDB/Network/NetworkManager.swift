//
//  NetworkManager.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import Moya

final class NetworkManager: Networkable {

    public var provider = MoyaProvider<NasaAPI>(plugins: [NetworkLoggerPlugin()])
    
    func fetchOppurtunityRover(completion: @escaping ([Photo]) -> ()) {
        provider.request(.opportunity) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                    completion(results.photos)
                    print(results.photos.first?.earthDate)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
    
    func fetchCuriosityRover(completion: @escaping ([Photo]) -> ()) {
        provider.request(.curiosity) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                    completion(results.photos)
                    print(results.photos.first?.earthDate)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
    
    func fetchSpiritRover(completion: @escaping ([Photo]) -> ()) {
        provider.request(.spirit) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                    completion(results.photos)
                    print(results.photos.first?.earthDate)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
    
    func opportunityRoverCameraSearch(camera: String, completion: @escaping ([Photo]) -> ()) {
        provider.request(.opportunitySearch(camera: camera)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                    completion(results.photos)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
    
    func curiosityRoverCameraSearch(camera: String, completion: @escaping ([Photo]) -> ()) {
        provider.request(.curiositySearch(camera: camera)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                    completion(results.photos)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
    
    func spiritRoverCameraSearch(camera: String, completion: @escaping ([Photo]) -> ()) {
        provider.request(.spiritSearch(camera: camera)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                    completion(results.photos)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
    
    
}

