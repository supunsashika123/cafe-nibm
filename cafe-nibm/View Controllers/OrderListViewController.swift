//
//  OrderListViewController.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-04-25.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class OrderListViewController: UIViewController {
    @Published var items = [Order]()
    @IBOutlet weak var tblItems: UITableView!
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchOrders {
            self.tblItems.reloadData()
        }
        
        tblItems.rowHeight = 70
        tblItems.delegate = self
        tblItems.dataSource = self
    }
    
    
    func fetchOrders(completed:@escaping ()-> ()) {
        let db = Firestore.firestore()
        
        //        spinner.startAnimating()
        let userId = userDefaults.value(forKey: "USER_ID") as? String
        
        db.collection("orders").whereField("user_id", isEqualTo: userId!).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
               
                for itm in snapshot!.documents {
                    do {
                       
                        let objItem = try itm.data(as: Order.self)
                        print(objItem)
                        self.items.append(objItem!)
                    } catch  {
                        print("parse error!")
                    }
                }
                
                //                self.spinner.stopAnimating()
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }
    }
    
}

extension OrderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if(tableView == self.tblItems) {
        //            performSegue(withIdentifier: "showItemDetails", sender: self)
        //        }
        //
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension OrderListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemData = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrdersTableCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        
        cell.title?.text = dateFormatter.string(from: itemData.date)
        cell.info?.text = "Status - \(itemData.status)"
        cell.price?.text = "LKR \(String(format: "%.2f", itemData.total_price))"
        
        return cell
        
    }
}





class OrdersTableCell: UITableViewCell {
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var info : UILabel!
    @IBOutlet weak var price : UILabel!
}
