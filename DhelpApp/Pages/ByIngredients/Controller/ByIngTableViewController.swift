//
//  ByIngTableViewController.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 06/04/21.
//

import UIKit

class ByIngTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    let data = ["Nasi","Semangak","Apple","Pizza"]
    var filterData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        filterData = data
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = filterData[indexPath.row]
        return cell
    }
    
    // search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []

        if searchText == "" {
            filterData = data
        }
        else{
        for makanan in data {
            if makanan.lowercased().contains(searchText.lowercased()){
                filterData.append(makanan)
            }
        }
        }
        self.tableView.reloadData()
    }
}

extension ByIngTableViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "By Ingredients"
        navigationController?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    

}
