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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @Published var items = [Item]()
    var basket: [Basket] = []
    
    let userDefaults = UserDefaults()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let data = UserDefaults.standard.value(forKey:"BASKET") as? Data {
            let userBasket = try? PropertyListDecoder().decode(Array<Basket>.self, from: data)
            
            basket = userBasket!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems {
            self.tblItems.reloadData()
        }
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: [])
        
        tblItems.rowHeight = 70
        tblItems.delegate = self
        tblItems.dataSource = self
        
    }
    
    func fetchItems(completed:@escaping ()-> ()) {
        let db = Firestore.firestore()
        
        spinner.startAnimating()
        
        db.collection("items").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for itm in snapshot!.documents {
                    do {
                        let objItem = try itm.data(as: Item.self)
                        self.items.append(objItem!)
                    } catch {
                        print("JSON Parse error!")
                    }
                }
                
                self.spinner.stopAnimating()
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ItemDetailsViewController {
            destination.item = items[(tblItems.indexPathForSelectedRow?.row)!]
        }
    }
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showItemDetails", sender: self)
    }
    
}


extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsTableCell
        
        let itemData = items[indexPath.row]
        
        cell.title?.text = itemData.name
        cell.info?.text = itemData.description
        cell.price?.text = "LKR \(String(format: "%.2f", itemData.price))"
        
        return cell
    }
    
}

class ItemsTableCell: UITableViewCell {
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var info : UILabel!
    @IBOutlet weak var price : UILabel!
}
