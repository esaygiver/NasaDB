//
//  OpportunityViewController.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit
import Moya

final class OpportunityViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var opportunityData = [Photo]()
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        getsRoverData()
    }
}


//MARK: - Network Request
extension OpportunityViewController {
    func getsRoverData() {
        networkManager.fetchOppurtunityRover { [weak self] photos in
            guard let self = self else { return }
            self.opportunityData = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
    
//MARK: - CollectionView Delegate & DataSource
extension OpportunityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return opportunityData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpportunityCell", for: indexPath) as! OpportunityCollectionViewCell
        let selectedCell = opportunityData[indexPath.row]
        cell.configureOutlets(with: selectedCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedCell = opportunityData[indexPath.row]
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpViewController
        popOverVC.roverData = selectedCell
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        
    }
    
}
