//
//  HomeTableViewController.swift
//  EasyBrowser
//
//  Created by José Eduardo Pedron Tessele on 24/08/19.
//  Copyright © 2019 José P Tessele. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var links = ["google.com"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLink))
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Link", for: indexPath)
        cell.textLabel?.text = links[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? ViewController{
            vc.website = links[indexPath.row]
            vc.websites = links
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addLink(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddLink") as? LinkViewController{
            navigationController?.pushViewController(vc, animated: true)
        }

    }

}
