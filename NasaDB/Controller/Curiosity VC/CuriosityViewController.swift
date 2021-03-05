//
//  ViewController.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

enum CameraListState {
    case searching, loaded, empty
}

final class CuriosityViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var noPhotoView: UIView!
    @IBOutlet weak var pageSegment: UISegmentedControl!
    @IBOutlet weak var cameraPicker: UIPickerView!
    
    lazy var curiosityData = [Photo]()
    public var networkManager = NetworkManager()
    lazy var cameraTypes = ["FHAZ", "RHAZ", "MAST", "CHEMCAM", "MAHLI", "MARDI", "NAVCAM", "PANCAM", "MINITES"]
    lazy var cameraQuery: String = ""
    lazy var selectedPage: Int = 1
    
    var screenState: CameraListState? {
        didSet {
            if screenState == .searching {
                collectionView.isHidden = true
                pageSegment.isHidden = true
                noPhotoView.isHidden = true
                filterView.isHidden = false
            } else if screenState == .loaded {
                filterView.isHidden = true
                pageSegment.isHidden = false
                noPhotoView.isHidden = true
                collectionView.isHidden = false
            } else {
                filterView.isHidden = true
                pageSegment.isHidden = true
                collectionView.isHidden = true
                noPhotoView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDelegatios()
        getsRoverData(page: selectedPage)
    }
    
    func setUpDelegatios() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        cameraPicker.delegate = self
        cameraPicker.dataSource = self
        
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        if screenState == .searching {
            fetchCameraTypeOfCuriosityRover(camera: cameraQuery, page: selectedPage)
            screenState = .loaded
        } else {
            screenState = .searching
        }
    }
    @IBAction func selectedPageIndex(_ sender: UISegmentedControl) {
        selectedPage = Int(pageSegment.titleForSegment(at: pageSegment.selectedSegmentIndex)!)!
        getsRoverData(page: selectedPage)
    }
    
}

//MARK: - Network Request
extension CuriosityViewController {
    func getsRoverData(page: Int) {
        networkManager.fetchCuriosityRover(page: page) { [weak self] photos in
            guard let self = self else { return }
            self.curiosityData = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchCameraTypeOfCuriosityRover(camera: String, page: Int) {
        networkManager.curiosityRoverCameraSearch(camera: camera, page: page) { [weak self] photos in
            guard let self = self else { return }
            if photos.isEmpty {
                self.screenState = .empty
            } else {
                self.curiosityData = photos
                self.screenState = .loaded
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - CollectionView Delegate & DataSource & Flowlayout
extension CuriosityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curiosityData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuriosityCell", for: indexPath) as! CuriosityCollectionViewCell
        let selectedCell = curiosityData[indexPath.row]
        cell.configureImages(with: selectedCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedCell = curiosityData[indexPath.row]
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
extension CuriosityViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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


