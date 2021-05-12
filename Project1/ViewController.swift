//
//  ViewController.swift
//  Project1
//
//  Created by Iyin Raphael on 5/12/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var categories = ["Airplanes", "Beaches", "Bridges", "Cats",
    "Cities", "Dogs", "Earth", "Forests", "Galaxies", "Landmarks",
    "Mountains", "People", "Roads", "Sports", "Sunsets"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category
        return cell
    }

}

