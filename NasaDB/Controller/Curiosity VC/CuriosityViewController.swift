//
//  ViewController.swift
//  NasaDB
//
//  Created by admin on 3.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

final class CuriosityViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var noPhotoView: UIView!
    @IBOutlet weak var cameraPicker: UIPickerView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var searchingPage: UILabel!
    @IBOutlet weak var pageStepper: UIStepper!
    
    lazy var curiosityData = [Photo]()
    public var networkManager = NetworkManager()
    lazy var cameraTypes = ["FHAZ", "RHAZ", "MAST", "CHEMCAM", "MAHLI", "MARDI", "NAVCAM", "PANCAM", "MINITES"]
    lazy var cameraQuery: String = "FHAZ"
    // For default case
    lazy var nextPage: Int = 1
    
    var screenState: CameraListState? {
        didSet {
            switch screenState {
            case .searching:
                collectionView.isHidden = true
                noPhotoView.isHidden = true
                filterView.isHidden = false
                filterButton.title = ""
            case .loaded:
                filterView.isHidden = true
                noPhotoView.isHidden = false
                collectionView.isHidden = false
                filterButton.title = "Filter"
            case .empty:
                filterView.isHidden = true
                collectionView.isHidden = true
                noPhotoView.isHidden = false
                filterButton.title = "Filter"
            case .none:
                print("we got an issue about changing states of screen!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenState = .loaded
        setUpDelegatios()
        getsRoverData(page: nextPage)
        
    }
    
    func setUpDelegatios() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        cameraPicker.delegate = self
        cameraPicker.dataSource = self
        getCurvyButton(searchButton)
        getCurvyButton(closeButton)
        getCurvyButton(seeAllButton)
        
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        if screenState == .loaded || screenState == .empty {
            screenState = .searching
        }
    }
    
    @IBAction func pageValueChangedAtSearching(_ sender: UIStepper) {
        searchingPage.text = Int(pageStepper.value).description
    }
    
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        curiosityData = []
        getsRoverData(page: 1)
        screenState = .loaded
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        curiosityData = []
        fetchCameraTypeOfCuriosityRover(camera: cameraQuery, page: Int(searchingPage.text!)!)
        screenState = .loaded
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        screenState = .loaded
    }
}

//MARK: - Network Request
extension CuriosityViewController {
    func getsRoverData(page: Int) {
        networkManager.fetchCuriosityRover(page: page) { [weak self] photos in
            guard let self = self else { return }
            if photos.isEmpty {
                self.screenState = .empty
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            } else {
                self.curiosityData.append(contentsOf: photos)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            }
        }
    }
    
    
    func fetchCameraTypeOfCuriosityRover(camera: String, page: Int) {
        networkManager.curiosityRoverCameraSearch(camera: camera, page: page) { [weak self] photos in
            guard let self = self else { return }
            if photos.isEmpty {
                self.screenState = .empty
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            } else {
                self.curiosityData.append(contentsOf: photos)
                self.screenState = .loaded
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuriosityCell", for: indexPath) as! PhotoCollectionViewCell
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
    
    //MARK: - Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cameraQuery != "FHAZ" {
            if indexPath.row == self.curiosityData.count {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                fetchCameraTypeOfCuriosityRover(camera: cameraQuery, page: Int(searchingPage.text!)!)
            }
        } else {
            if indexPath.row == self.curiosityData.count - 1 {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                nextPage += 1
                getsRoverData(page: nextPage)
            }
        }
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

//MARK: - Button with curves
extension CuriosityViewController {
    func getCurvyButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
    }
}


