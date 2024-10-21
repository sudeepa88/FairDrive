//
//  HomeViewController.swift
//  TestFairDrive
//
//  Created by Sudeepa Pal on 19/10/24.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestoreInternal
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth


class HomeViewController: UIViewController, UITextFieldDelegate {
    
    private let locationManager = CLLocationManager()
    var currentAddress: String = ""
    
    let db = Firestore.firestore()
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    let userLocation: UITextField = {
        let location = UITextField()
        location.translatesAutoresizingMaskIntoConstraints = false
        location.layer.cornerRadius = 20
        location.backgroundColor = .white
        location.placeholder = "Enter Location"
        location.textColor = .black
        location.borderStyle = .roundedRect
        location.returnKeyType = .done
        return location
    }()
    
    
    let dropLocation: UITextField = {
        let location = UITextField()
        location.translatesAutoresizingMaskIntoConstraints = false
        location.layer.cornerRadius = 20
        location.backgroundColor = .white
        location.placeholder = "Enter Drop Location"
        location.textColor = .black
        location.borderStyle = .roundedRect
        location.returnKeyType = .done
        return location
    }()
    
    
    let currentLcBtn: UIButton = {
        let btnbtn = UIButton()
        btnbtn.translatesAutoresizingMaskIntoConstraints = false
        btnbtn.layer.cornerRadius = 20
        btnbtn.backgroundColor = .systemRed
        btnbtn.setTitle("Current Location", for: .normal)
        btnbtn.addTarget(self, action: #selector(currentLocationAccess), for: .touchUpInside)
        btnbtn.setTitleColor(.white, for: .normal)
        return btnbtn
    }()
    
    let saveLcBtn: UIButton = {
        let btnbtn = UIButton()
        btnbtn.translatesAutoresizingMaskIntoConstraints = false
        btnbtn.layer.cornerRadius = 20
        btnbtn.backgroundColor = .systemBlue
        btnbtn.setTitle("SAVE", for: .normal)
        btnbtn.setTitleColor(.white, for: .normal)
        btnbtn.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return btnbtn
    }()
    
    let rideHistory: UIButton = {
        let btnbtn = UIButton()
        btnbtn.translatesAutoresizingMaskIntoConstraints = false
        btnbtn.layer.cornerRadius = 20
        btnbtn.backgroundColor = .purple
        btnbtn.setTitle("Past", for: .normal)
        btnbtn.addTarget(self, action: #selector(historyList), for: .touchUpInside)
        btnbtn.setTitleColor(.white, for: .normal)
        return btnbtn
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        self.locationManager.delegate = self
        userLocation.delegate = self
        dropLocation.delegate = self
        
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
        
        setUserLocationConstraints()
        setUserDropLocation()
        setCurrentLocation()
        setMapConstraints()
        setBtnHisConstraints()
        setSaveBtnConstraints()
    }
    
    private func setUserLocationConstraints() {
        
        view.addSubview(userLocation)
        
        NSLayoutConstraint.activate([
            userLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            userLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userLocation.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    private func setUserDropLocation() {
        view.addSubview(dropLocation)
        NSLayoutConstraint.activate([
            dropLocation.topAnchor.constraint(equalTo: userLocation.bottomAnchor, constant: 5),
            dropLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dropLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dropLocation.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setCurrentLocation() {
        view.addSubview(currentLcBtn)
        NSLayoutConstraint.activate([
            currentLcBtn.topAnchor.constraint(equalTo: dropLocation.bottomAnchor, constant: 10),
            currentLcBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            currentLcBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            currentLcBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func setMapConstraints() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: currentLcBtn.bottomAnchor, constant: 5),  // Anchoring to the top of the view
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setSaveBtnConstraints() {
        view.addSubview(saveLcBtn)
        NSLayoutConstraint.activate([
            saveLcBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            saveLcBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveLcBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            saveLcBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func setBtnHisConstraints() {
        view.addSubview(rideHistory)
        NSLayoutConstraint.activate([
            rideHistory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            rideHistory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            rideHistory.widthAnchor.constraint(equalToConstant: 50),
            rideHistory.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    
    @objc func logoutAction() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error Is Here --> ", signOutError)
        }
    }
    
    
    @objc func historyList() {
        //print("Hii")
        let historyListVC = HistotyListVC()
        navigationController?.pushViewController(historyListVC, animated: true)
    }
    
    @objc func currentLocationAccess() {
        userLocation.text = currentAddress
    }
    
    @objc func saveButtonTapped() {
        
        // Create the activity indicator (loader)
        let loader = UIActivityIndicatorView(style: .large)
        loader.center = self.view.center
        loader.hidesWhenStopped = true
        self.view.addSubview(loader)
        
        DispatchQueue.main.async {
            loader.color = UIColor.red
            loader.startAnimating()
        }
        
        self.view.isUserInteractionEnabled = false
        
        
        
        if let pickupLocation = userLocation.text,
           let dropLocation = dropLocation.text,
           let userCurrentlyIn = Auth.auth().currentUser?.email {
            
            db.collection("history").addDocument(data: [
                "userName" : userCurrentlyIn,
                "userPickUp" : pickupLocation,
                "userDropLocation" : dropLocation
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore",e)
                } else {
                    print("Data Saved Successfully")
                    
                    
                    self.userLocation.text = ""
                    self.dropLocation.text = ""
                    
                    
                    let alertController = UIAlertController(title: "Success", message: "Your Rides Have Been Saved!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        
                        loader.stopAnimating()
                        self.view.isUserInteractionEnabled = true

                        
                        let historyListVC = HistotyListVC()
                        self.navigationController?.pushViewController(historyListVC, animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
//                    loader.stopAnimating()
//                    self.view.isUserInteractionEnabled = true
                }
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() 
        return true
    }
}


extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.currentAddress = "\(placemark.thoroughfare ?? "") \(placemark.locality ?? "")"
                // print("my current Address is : ", self.currentAddress)
            }
        }
    }
    
}
