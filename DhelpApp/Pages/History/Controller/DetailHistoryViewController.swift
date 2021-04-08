//
//  DetailHistoryViewController.swift
//  DhelpApp
//
//  Created by Graciela gabrielle Angeline on 08/04/21.
//

import UIKit

struct Section{
    var header: String
    var list: [DetailHistory]
}
//
//enum DetailHistory2{
//    case staticCell(model: DetailHistory)
//    case switchCell(model: )
//}

struct DetailHistory{
    var item: [String]?
    var gram: [String]?
}


class DetailHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    let tableView: UITableView = {
        let Detailtable = UITableView (frame: .zero, style: .grouped)
        
        Detailtable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return Detailtable
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func configure(){
        models.append(Section(header: "Breakfast", list: [
            DetailHistory(item: ["Nasi Putih"], gram: ["16 gr"]),
            DetailHistory(item: ["Wortel"], gram: ["4 gr"]),
        ]))
        
        models.append(Section(header: "Lunch", list: [
            DetailHistory(item: ["Ayam Goreng"], gram: ["30 gr"]),
            DetailHistory(item: ["bayam"], gram: ["20 gr"]),
        ]))
        
        models.append(Section(header: "Dinner", list: [
            DetailHistory(item: ["Ayam Goreng"], gram: ["30 gr"]),
            DetailHistory(item: ["bayam"], gram: ["20 gr"]),
        ]))
        
        models.append(Section(header: "Snack", list: [
            DetailHistory(item: ["Ayam Goreng"], gram: ["30 gr"]),
            DetailHistory(item: ["bayam"], gram: ["20 gr"]),
        ]))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.section].list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "test"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}

extension DetailHistoryViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
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
