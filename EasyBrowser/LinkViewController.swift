//
//  LinkViewController.swift
//  EasyBrowser
//
//  Created by José Eduardo Pedron Tessele on 26/08/19.
//  Copyright © 2019 José P Tessele. All rights reserved.
//

import UIKit

class LinkViewController: UIViewController {

    @IBOutlet var newLink: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNewLink(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeTableViewController{
            if let newLink = newLink.text{
                vc.links.append(newLink)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    
    }
}
