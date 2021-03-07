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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = false
        
        lblTitle.text = item?.name
        lblDescription.text = item?.description
        lblPrice.text = "LKR \(String(format: "%.2f", item!.price))"
    }
    

    @IBAction func onClickBtnAddToBasket(_ sender: Any) {
    }
}
