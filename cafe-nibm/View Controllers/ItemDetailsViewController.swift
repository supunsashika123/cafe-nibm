//
//  ItemDetailsViewController.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-07.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnAddToBasket: UIButton!
    
    var item:Item?
    
    var basket: [Basket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = false
        
        lblTitle.text = item?.name
        lblDescription.text = item?.description
        lblPrice.text = "LKR \(String(format: "%.2f", item!.price))"
    }
    
    
    @IBAction func onClickBtnAddToBasket(_ sender: Any) {
        
        if let data = UserDefaults.standard.value(forKey:"BASKET") as? Data {
            let oldBasket = try? PropertyListDecoder().decode(Array<Basket>.self, from: data)
            
            basket = oldBasket!
            
            let newItem = Basket(name: item!.name, qty: 1, total: 100.00)
            
            basket.append(newItem)
            
        }
        
        saveBasket(basket)
        
        _ = navigationController?.popViewController(animated: true)
    }
}
