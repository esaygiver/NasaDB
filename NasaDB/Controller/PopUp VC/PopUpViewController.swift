//
//  PopUpViewController.swift
//  NasaDB
//
//  Created by admin on 4.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

final class PopUpViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var roverImage: UIImageView!
    @IBOutlet weak var cameraName: UILabel!
    @IBOutlet weak var roverName: UILabel!
    @IBOutlet weak var launchingDate: UILabel!
    @IBOutlet weak var earthDate: UILabel!
    @IBOutlet weak var roverStatus: UILabel!
    @IBOutlet weak var photoDate: UILabel!
    @IBOutlet weak var closePopUp: UIButton!
    
    var roverData: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        updatingOutlets()
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
}

extension PopUpViewController {
    func updatingOutlets() {
        roverImage.fetchImage(from: roverData.image)
        roverName.text = "Rover: \(roverData.rover.name)"
        cameraName.text = "Camera: \(roverData.camera.name)"
        launchingDate.text = "Launch: \(roverData.rover.launchDate)"
        earthDate.text = "Earth: \(roverData.earthDate)"
        roverStatus.text = "Status: \(roverData.rover.status)"
        photoDate.text = "Photo: \(roverData.rover.landingDate)"
        getCurvyButton(closePopUp)
    }
}

//MARK: - Button with curves
extension PopUpViewController {
    func getCurvyButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
    }
}
