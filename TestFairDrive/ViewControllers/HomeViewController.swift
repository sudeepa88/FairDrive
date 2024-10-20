//
//  HomeViewController.swift
//  TestFairDrive
//
//  Created by Sudeepa Pal on 19/10/24.
//

import UIKit
import MapKit
import CoreLocation


class HomeViewController: UIViewController {
    
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
        return location
    }()
    
    
    let currentLcBtn: UIButton = {
        let btnbtn = UIButton()
        btnbtn.translatesAutoresizingMaskIntoConstraints = false
        btnbtn.layer.cornerRadius = 20
        btnbtn.backgroundColor = .systemRed
        btnbtn.setTitle("Current Location", for: .normal)
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
    
    @objc func historyList() {
        print("Hii")
        let historyListVC = HistotyListVC()
        navigationController?.pushViewController(historyListVC, animated: true)
    }
    
}


