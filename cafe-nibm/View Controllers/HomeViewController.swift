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
    @IBOutlet weak var tblBasket: UITableView!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    @Published var items = [Item]()
    var basket: [Basket] = []
    
    let userDefaults = UserDefaults()
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let data = UserDefaults.standard.value(forKey:"BASKET") as? Data {
            let userBasket = try? PropertyListDecoder().decode(Array<Basket>.self, from: data)
            
            basket = userBasket!
            
            if((basket.count) > 0){
                btnPlaceOrder.isHidden = false
            }
            
            self.tblBasket.reloadData()
            
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
        
        tblBasket.delegate = self
        tblBasket.dataSource = self
        
        btnPlaceOrder.isHidden = true
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
    
    
    @IBAction func onPlaceOrderBtnClick(_ sender: Any) {
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == self.tblItems) {
            performSegue(withIdentifier: "showItemDetails", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblItems {
            return items.count
        }
        
        if tableView == self.tblBasket {
            return basket.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if tableView == self.tblItems {
            let itemData = items[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsTableCell
            
            cell.title?.text = itemData.name
            cell.info?.text = itemData.description
            cell.price?.text = "LKR \(String(format: "%.2f", itemData.price))"
            
            return cell
        }
        
        if tableView == self.tblBasket {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath) as! BasketTableCell
            
            let itemData = basket[indexPath.row]
            
            cell2.itemName?.text = itemData.name
            
            cell2.basketTableRowObject =
                {
                    self.basket.remove(at: indexPath.row)
                    saveBasket(self.basket)
                    
                    print(self.basket.count)
                    self.btnPlaceOrder.isHidden = (self.basket.count) == 0
                    
                    
                    self.tblBasket.reloadData()
                }
            
            return cell2
        }
        return UITableViewCell()
    }
    
    
}





class ItemsTableCell: UITableViewCell {
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var info : UILabel!
    @IBOutlet weak var price : UILabel!
}

class BasketTableCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    
    var basketTableRowObject : (() -> Void)? = nil
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
    @IBAction func onRemoveBtnClick(_ sender: Any) {
        
        if let btnAction = self.basketTableRowObject
        {
            btnAction()
            
        }
    }
    

}
