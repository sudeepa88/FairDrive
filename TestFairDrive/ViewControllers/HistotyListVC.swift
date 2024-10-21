//
//  HistotyListVC.swift
//  TestFairDrive
//
//  Created by Sudeepa Pal on 20/10/24.
//

import UIKit
import FirebaseFirestore


class HistotyListVC: UIViewController {
    
    let tableView = UITableView()
    
    let db = Firestore.firestore()
    
    var cellTitles: [LocationDetails] = [
        LocationDetails(dropLoc: "Example", picupLoc: "History"),
        LocationDetails(dropLoc: "Test", picupLoc: "Kolkata")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        self.title = "Your Bookings"
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        setContsForTblV()
        
        readOrders()
    }
    
    private func setContsForTblV() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    func readOrders() {
        cellTitles =  []
        db.collection("history").getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There is an issue to retrieving from Firestore", e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let drpLoc = data["userDropLocation"] as? String ,
                           let picLoc = data["userPickUp"] as? String {
                            print (picLoc,"-------", drpLoc)
                            let updateLocations = LocationDetails(dropLoc: drpLoc, picupLoc: picLoc)
                            self.cellTitles.append(updateLocations)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
}

extension HistotyListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var cellStyle = "\(cellTitles[indexPath.row].picupLoc)      ----    \(cellTitles[indexPath.row].dropLoc)"
        
        cell.textLabel?.text = cellStyle
        
        return cell
    }
    
    
}
