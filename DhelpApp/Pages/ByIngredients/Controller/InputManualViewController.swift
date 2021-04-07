//
//  InputManualViewController.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 06/04/21.
//

import UIKit

class SectionName{
    var section: String?
    var item: [String]?
    
    init(section: String, item: [String]) {
        self.section = section
        self.item = item
    }
}

class SectionName2{
    var section2: String?
    var itemDetail: [String]?
    var itemSub: [String]?
    
    init(section2: String, itemDetail: [String], itemSub: [String]) {
        self.section2 = section2
        self.itemDetail = itemDetail
        self.itemSub = itemSub
    }
}

class SectionName3{
    var section3: String?
    var nameText: [String]?
    
    init(section3: String, nameText: [String]) {
        self.section3 = section3
        self.nameText = nameText
    }
}

class InputManualViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: Ingredient?

    var sectionName = [SectionName]()
    
    var sectionName2 = [SectionName2]()
    
    var sectionName3 = [SectionName3]()
    
    
    
    @IBOutlet weak var mealTimeTable: UITableView!
    @IBOutlet weak var infoTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionName.append(SectionName.init(section: "Time", item: ["Meal"]))
        
        sectionName2.append(SectionName2.init(section2: "Detail", itemDetail: [data!.name], itemSub: ["\(data!.size) gr"]))

        mealTimeTable.tag = 1
        infoTable.tag = 2
        
        mealTimeTable.delegate = self
        mealTimeTable.dataSource = self
        
        infoTable.delegate = self
        infoTable.dataSource = self
        
        mealTimeTable.register(TableViewCell.nib() , forCellReuseIdentifier: TableViewCell.identifier)
        
        infoTable.register(LabelTableViewCell.nib(), forCellReuseIdentifier: LabelTableViewCell.identifier)
        infoTable.register(ServingSizeTableViewCell.nib(), forCellReuseIdentifier: ServingSizeTableViewCell.identifier)
        // Do any additional setup after loading the view.
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        switch tableView.tag {
//        case 1:
//            return sectionName.count
//        case 2:
//            return 10
//        default:
//            return 1
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 1:
            return sectionName[section].item?.count ?? 0
        case 2:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
            cell.textLabel?.text = sectionName[indexPath.section].item?[indexPath.row]
            return cell
        case 2:
            if indexPath.row > 1{
                let customCell2 = tableView.dequeueReusableCell(withIdentifier: ServingSizeTableViewCell.identifier, for: indexPath) as!
                ServingSizeTableViewCell
                return customCell2
            }
            
            if indexPath.row > 0{
                let customCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as!
                LabelTableViewCell
                customCell.labelCalories.text = "\(self.data!.calorie) kcal"
                customCell.labelSugar.text = "\(self.data!.sugar) gr"
                customCell.labelCarbo.text = "\(self.data!.carbs) gr"
                return customCell
            }
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            cell2.textLabel?.text = sectionName2[indexPath.section].itemDetail?[indexPath.row]
            cell2.detailTextLabel?.text = sectionName2[indexPath.section].itemSub?[indexPath.row]
            return cell2
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cel", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView.tag {
        case 1:
            return 44
        case 2:
            return 70
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionName[section].section
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch tableView.tag {
        case 1:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            view.backgroundColor = .gray
            
            let labelName = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
            labelName.text = sectionName[section].section
            view.addSubview(labelName)
            
            return view
        case 2:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            view.backgroundColor = .gray
            
            let labelName = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
            labelName.text = sectionName2[section].section2
            view.addSubview(labelName)
            
            return view
        default:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView.tag {
        case 1:
            return 40
        case 2:
            return 40
        default:
            return 1
        }
    }

}

extension InputManualViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "By Ingredients"
        navigationController?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
