//
//  CuriosityCollectionViewCell.swift
//  NasaDB
//
//  Created by admin on 4.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

class CuriosityCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    func configureImages(with model: Photo) {
        self.imageView.fetchImage(from: model.image)
    }
}
