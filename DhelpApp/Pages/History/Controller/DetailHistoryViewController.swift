//
//  DetailHistoryViewController.swift
//  DhelpApp
//
//  Created by Graciela gabrielle Angeline on 08/04/21.
//

import UIKit

struct Section{
    var header: String
    var list: [CellType]
}

enum CellType{
    case staticCell(model:DetailHistory)
    case switchCell(model:CustomCell)
}

struct CustomCell{
    var namaGram: String
}

struct DetailHistory{
    var item: String
    var gram: [String]?
}

class DetailHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var dataCalories = "20 kcal"
    var dataGula = "20 gr"
    var dataCarb = "200 gr"


    @IBOutlet weak var dateDetailHistory: UILabel!
    
    let tableView: UITableView = {
        let Detailtable = UITableView (frame: CGRect(x: 0, y: 135, width: 390, height: 696), style: .grouped)
        
        Detailtable.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        
        return Detailtable
    }()
    
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
       
        
        tableView.register(CustomTableViewCell.nib(), forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        
    }
    
    func configure(){
        models.append(Section(header: "", list: [
            .switchCell(model: CustomCell(namaGram: ""))
        ]))
        
        models.append(Section(header: "Breakfast", list: [
            .staticCell(model: DetailHistory(item: "Nasi Putih", gram: ["16 gr"])),
            .staticCell(model: DetailHistory(item: "Wortel", gram: ["4 gr"])),
        ]))
        
        models.append(Section(header: "Lunch", list: [
            .staticCell(model: DetailHistory(item: "Ayam Goreng", gram: ["30 gr"])),
            .staticCell(model: DetailHistory(item: "bayam", gram: ["20 gr"])),
        ]))
        
        models.append(Section(header: "Dinner", list: [
            .staticCell(model: DetailHistory(item: "Ayam Goreng", gram: ["30 gr"])),
            .staticCell(model: DetailHistory(item: "bayam", gram: ["20 gr"])),
        ]))
        
        models.append(Section(header: "Snack", list: [
            .staticCell(model: DetailHistory(item: "Ayam Goreng", gram: ["30 gr"])),
            .staticCell(model: DetailHistory(item: "bayam", gram: ["20 gr"])),
        ]))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0{
            return 70
        }
        return 40
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
        
        switch model.self{
            case .staticCell(let model):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else{
                    return UITableViewCell()
                }
                
                cell.configure(with: model)
                return cell
            
            case .switchCell(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as!
                        CustomTableViewCell
                
                cell.labelCalories.text = dataCalories
                cell.labelSugar.text = dataGula
                cell.labelCarbo.text = dataCarb
                return cell
        }
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
        self.tabBarController?.tabBar.isHidden = true
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
