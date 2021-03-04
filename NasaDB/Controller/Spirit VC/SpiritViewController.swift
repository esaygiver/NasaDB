//
//  SpiritViewController.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

final class SpiritViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var spiritData = [Photo]()
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDelegatios()
        getsRoverData()
    }
    
    func setUpDelegatios() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - Network Request
extension SpiritViewController {
    func getsRoverData() {
        networkManager.fetchSpiritRover { [weak self] photos in
            guard let self = self else { return }
            self.spiritData = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
//MARK: - CollectionView Delegate & DataSource
extension SpiritViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spiritData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpiritCell", for: indexPath) as! SpiritCollectionViewCell
        let selectedCell = spiritData[indexPath.row]
        cell.configureImages(with: selectedCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedCell = spiritData[indexPath.row]
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpViewController
        popOverVC.roverData = selectedCell
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    
}
