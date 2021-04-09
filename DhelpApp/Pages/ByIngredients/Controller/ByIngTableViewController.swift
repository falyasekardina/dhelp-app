//
//  ByIngTableViewController.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 06/04/21.
//

import UIKit


class ByIngTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var data: [Ingredient]?
    var filterData: [Ingredient]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        parseJson()
        filterData = data
        self.tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.filterData?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.data?[indexPath.row] ?? "Row")
        performSegue(withIdentifier: "DetailByIngredients", sender: self.filterData?[indexPath.row])
    }
    
    // search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData.removeAll()

        if searchText == "" {
            filterData = data
        } else {
            for makanan in data! {
                if makanan.name.lowercased().contains(searchText.lowercased()){
                    filterData.append(makanan)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    func parseJson() {
        guard let path = Bundle.main.path(forResource: "Ingredients", ofType: "json") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            self.data = try JSONDecoder().decode([Ingredient].self, from: jsonData)
        } catch {
            print("Error: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? InputManualViewController {
            guard let ingredient = sender as? Ingredient else { return }
            destinationVC.data = ingredient
        }
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
    

    // Hello World
}
