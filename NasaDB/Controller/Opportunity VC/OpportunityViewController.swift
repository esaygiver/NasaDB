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
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var noPhotoView: UIView!
    @IBOutlet weak var cameraPicker: UIPickerView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    lazy var opportunityData = [Photo]()
    public var networkManager = NetworkManager()
    lazy var cameraTypes = ["FHAZ", "RHAZ", "MAST", "CHEMCAM", "MAHLI", "MARDI", "NAVCAM", "PANCAM", "MINITES"]
    lazy var cameraQuery: String = ""
    lazy var selectedPage: Int = 1
    
    var screenState: CameraListState? {
        didSet {
            switch screenState {
            case .searching:
                collectionView.isHidden = true
                noPhotoView.isHidden = true
                filterView.isHidden = false
            case .loaded:
                filterView.isHidden = true
                noPhotoView.isHidden = true
                collectionView.isHidden = false
            default:
                filterView.isHidden = true
                collectionView.isHidden = true
                noPhotoView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDelegations()
        getsRoverData(page: selectedPage)
    }
    
    func setUpDelegations() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        cameraPicker.delegate = self
        cameraPicker.dataSource = self
        getCurvyButton(searchButton)
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        if screenState == .searching {
            screenState = .loaded
        } else {
            screenState = .searching
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        fetchCameraTypeOfOpportunityRover(camera: cameraQuery, page: selectedPage)
        screenState = .loaded
        
    }
}

//MARK: - Network Request
extension OpportunityViewController {
    func getsRoverData(page: Int) {
        networkManager.fetchOppurtunityRover(page: page) { [weak self] photos in
            guard let self = self else { return }
            self.opportunityData = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchCameraTypeOfOpportunityRover(camera: String, page: Int) {
        networkManager.opportunityRoverCameraSearch(camera: camera, page: page) { [weak self] photos in
            guard let self = self else { return }
            if photos.isEmpty {
                self.screenState = .empty
            } else {
                self.opportunityData = photos
                self.screenState = .loaded
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - CollectionView Delegate & DataSource & Flowlayout
extension OpportunityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return opportunityData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpportunityCell", for: indexPath) as! OpportunityCollectionViewCell
        let selectedCell = opportunityData[indexPath.row]
        cell.configureImages(with: selectedCell)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        return size
    }
}

//MARK: - CameraPicker Delegate
extension OpportunityViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cameraTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cameraTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cameraQuery = cameraTypes[row]
    }
}

//MARK: - Button with curves
extension OpportunityViewController {
    func getCurvyButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
    }
}
