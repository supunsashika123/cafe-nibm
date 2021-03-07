//
//  HomeViewController.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-06.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tblItems: UITableView!
    
    @Published var items = [Item]()
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems {
            self.tblItems.reloadData()
        }
        
        tblItems.delegate = self
        tblItems.dataSource = self
        
    }
    
    func fetchItems(completed:@escaping ()-> ()) {
        let db = Firestore.firestore()
        
        db.collection("items").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for itm in snapshot!.documents{
                    do {
                        let objItem = try itm.data(as: Item.self)
                        self.items.append(objItem!)
                    } catch {
                        print("JSON Parse error!")
                    }
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped!!!")
    }
}


extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].name
        
        return cell
    }
    
}

