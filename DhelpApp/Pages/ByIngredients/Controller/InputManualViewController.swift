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

protocol InputManualViewControllerDelegate {
    func mealTimeSelected(mealTime: String)
    func servingSizeData(servingSize: String, isiServing: Bool)
}

extension InputManualViewController: InputManualViewControllerDelegate{
    func mealTimeSelected(mealTime: String) {
        mealTimeValue = mealTime
        isiText = true
        
        if isiText && isiText1{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func servingSizeData(servingSize: String, isiServing: Bool) {
        print("Serving Size Data \(servingSize)")
        print(isiServing)
        servingSizeValues = servingSize
        isiText1 = isiServing
        
        
        if isiText && isiText1{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

class InputManualViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var data: Ingredient?

    var isiText = false
    var isiText1 = false
    
    var sectionName = [SectionName]()
    
    var sectionName2 = [SectionName2]()
    
    var valueText : Bool = false
    
    var mealTimeValue = ""
    var servingSizeValues = ""
    
    @IBOutlet weak var mealTimeTable: UITableView!
    @IBOutlet weak var infoTable: UITableView!
    
    @IBOutlet weak var textTest: UITextField!
    
    var delegate: TransitionPageDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionName.append(SectionName.init(section: "Time", item: ["Meal"]))
        
        sectionName2.append(SectionName2.init(section2: "Detail", itemDetail: [data!.name], itemSub: ["\(data!.size) gr"]))

        mealTimeTable.tag = 1
        infoTable.tag = 2
        
        mealTimeTable.delegate = self
        mealTimeTable.dataSource = self
        mealTimeTable.isScrollEnabled = false
        
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.isScrollEnabled = false
        
        mealTimeTable.register(TableViewCell.nib() , forCellReuseIdentifier: TableViewCell.identifier)
        
        infoTable.register(LabelTableViewCell.nib(), forCellReuseIdentifier: LabelTableViewCell.identifier)
        infoTable.register(ServingSizeTableViewCell.nib(), forCellReuseIdentifier: ServingSizeTableViewCell.identifier)
        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        if valueText == false{
            print(valueText)
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            print(valueText)
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func donePressed(){
        let foodName = data!.name
        let calorieVal = Int64(data!.calorie)
        let carboVal = Double(data!.carbs)
        let sugarVal = Double(data!.sugar)
        let size = Double(servingSizeValues) // Harus Ambil Dr XIB file

        let newIntake = Intake(context: self.context)
        newIntake.id = UUID()
        newIntake.name = foodName
        newIntake.calories = calorieVal
        newIntake.carbs = carboVal
        newIntake.sugar = sugarVal
        newIntake.mealtime = mealTimeValue
        newIntake.servingsize = size ?? 0.0
        newIntake.manualsize = ""
        newIntake.createdat = Date()
        print(newIntake)

        do {
            try self.context.save()
        } catch {
            print("Error: \(error)")
        }

        delegate?.moveToListPage(controller: self, type: mealTimeValue)
    }
    
//    // Date() => 2021-04-11 08:04:00 +0000
//    func stringToDate(stringDate: String) -> Date {
//        stringToDate(stringDate: "10-04-2021")
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "UTC")
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        return dateFormatter.date(from: stringDate)!
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
            cell.delegate = self
            return cell
        case 2:
            if indexPath.row > 1{
                let customCell2 = tableView.dequeueReusableCell(withIdentifier: ServingSizeTableViewCell.identifier, for: indexPath) as!
                ServingSizeTableViewCell
                customCell2.delegate = self
                customCell2.textLabel?.text = "Serving Size"
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
            cell2.detailTextLabel?.textColor = #colorLiteral(red: 0.5178547502, green: 0.5172992349, blue: 0.5433796048, alpha: 1)
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
            if indexPath.row == 1{
                return 70
            } else{
                return 44
            }
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
            view.backgroundColor = #colorLiteral(red: 0.9491885304, green: 0.9486994147, blue: 0.9747329354, alpha: 1)
            
            let labelName = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
            labelName.text = sectionName[section].section
            labelName.textColor = #colorLiteral(red: 0.5178547502, green: 0.5172992349, blue: 0.5433796048, alpha: 1)
            view.addSubview(labelName)
            
            return view
        case 2:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            view.backgroundColor = #colorLiteral(red: 0.9491460919, green: 0.9487624764, blue: 0.9704342484, alpha: 1)
            
            let labelName = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
            labelName.text = sectionName2[section].section2
            labelName.textColor = #colorLiteral(red: 0.5178547502, green: 0.5172992349, blue: 0.5433796048, alpha: 1)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        navigationController?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
