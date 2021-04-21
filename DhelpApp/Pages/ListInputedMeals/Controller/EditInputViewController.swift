//
//  InputManualViewController.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 06/04/21.
//

import UIKit
import CoreData

class SectionNameMeal{
    var section: String?
    var item: [String]?
    
    init(section: String, item: [String]) {
        self.section = section
        self.item = item
    }
}

class SectionNameInfo{
    var section2: String?
    var itemDetail: [String]?
    var itemSub: [String]?
    
    init(section2: String, itemDetail: [String], itemSub: [String]) {
        self.section2 = section2
        self.itemDetail = itemDetail
        self.itemSub = itemSub
    }
}

protocol EditInputViewControllerDelegate {
    func mealTimeSelected(mealTime: String)
    func servingSizeData(servingSize: String, isiServing: Bool)
    func dataIn(namaData: String)
}

extension EditInputViewController: EditInputViewControllerDelegate {
    func mealTimeSelected(mealTime: String) {
        mealTimeValue = mealTime
        cekP = true
        
        if cekP && cekText{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func servingSizeData(servingSize: String, isiServing: Bool) {
        print("Serving Size Data \(servingSize)")
        servingSizeValues = servingSize
        hasil = (Int(servingSize) ?? 0) / (100)
        
        cekText = isiServing
        
        if cekP && cekText{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func dataIn(namaData: String)  {
        dataValue = "\(dataIntakes!.servingsize)"
        dataValue = namaData
    }
}



class EditInputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var hasil = 0
    
    var cekP = true
    var cekText = true
    
    var dataIntakes: Intake?
    
    var intakes: [Intake]?
    
    var savedata: Int?
    //var dataIngredient: Ingredient?
    
//    var dataIng: Ingredient?

    var sectionNameMeal = [SectionNameMeal]()
    
    var sectionNameInfo = [SectionNameInfo]()
    
    var dataValue = ""
    var mealTimeValue = ""
    var servingSizeValues = ""
    
    @IBOutlet weak var mealTimeTable: UITableView!
    @IBOutlet weak var infoTable: UITableView!
    
    
    var delegate: TransitionPageDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = dataIntakes else {return}
        guard let name = data.name else {return}
        
        sectionNameMeal.append(SectionNameMeal.init(section: "Time", item: ["Meal"]))
        sectionNameInfo.append(SectionNameInfo.init(section2: "Detail", itemDetail: ["\(name)"], itemSub: ["100 gr"]))

        mealTimeTable.tag = 1
        infoTable.tag = 2
        
        fetchdata()
        
        mealTimeTable.delegate = self
        mealTimeTable.dataSource = self
        mealTimeTable.isScrollEnabled = false
        mealTimeTable.isUserInteractionEnabled = false
        
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.isScrollEnabled = false
        infoTable.isUserInteractionEnabled = false
        
        mealTimeTable.register(EditTableViewCell.nib() , forCellReuseIdentifier: EditTableViewCell.identifier)
        
        infoTable.register(EditLabelTableViewCell.nib(), forCellReuseIdentifier: EditLabelTableViewCell.identifier)
        infoTable.register(EditServingSizeTableViewCell.nib(), forCellReuseIdentifier: EditServingSizeTableViewCell.identifier)
        // Do any additional setup after loading the view.
    }
    
    @objc func editPressed(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        mealTimeTable.isUserInteractionEnabled = true
        infoTable.isUserInteractionEnabled = true
        
    }
    
    @objc func donePressed(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
        mealTimeTable.isUserInteractionEnabled = false
        infoTable.isUserInteractionEnabled = false
        let foodName = dataIntakes!.name
        let calorieVal = Int64(dataIntakes!.calories)
        let carboVal = Double(dataIntakes!.carbs)
        let sugarVal = Double(dataIntakes!.sugar)
        let size = Double(servingSizeValues) // Harus Ambil Dr XIB file

        let newIntake = self.intakes![savedata!]
        newIntake.name = foodName
        newIntake.calories = calorieVal * Int64(hasil)
        newIntake.carbs = carboVal * Double(hasil)
        newIntake.sugar = sugarVal * Double(hasil)
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
    
    func fetchdata(){
        do{
        let request = Intake.fetchRequest() as NSFetchRequest<Intake>
            self.intakes = try context.fetch(request)
            for (index, dt) in self.intakes!.enumerated() {
                if dt.id == dataIntakes?.id {
                    savedata = index
                }
            }
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 1:
            return sectionNameMeal[section].item?.count ?? 0
        case 2:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 1:
            let csCell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as! EditTableViewCell
            csCell.field.text = "\(self.dataIntakes!.mealtime ?? "")"
            csCell.field.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            csCell.textLabel?.text = sectionNameMeal[indexPath.section].item?[indexPath.row]
            csCell.delegate = self
            return csCell
        case 2:
            if indexPath.row > 1{
                let csCell2 = tableView.dequeueReusableCell(withIdentifier: EditServingSizeTableViewCell.identifier, for: indexPath) as! EditServingSizeTableViewCell
                csCell2.sizeText.text = "\(self.dataIntakes!.servingsize)"
                csCell2.sizeText.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                csCell2.delegate = self
                csCell2.textLabel?.text = "Serving size"
                return csCell2
            }
            
            if indexPath.row > 0{
                let customCell = tableView.dequeueReusableCell(withIdentifier: EditLabelTableViewCell.identifier, for: indexPath) as!
                EditLabelTableViewCell
                customCell.labelCalories.text = "\(self.dataIntakes!.calories) kcal"
                customCell.labelSugar.text = "\(self.dataIntakes!.sugar) gr"
                customCell.labelKarbo.text = "\(self.dataIntakes!.carbs) gr"
                return customCell
            }
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            cell2.textLabel?.text = sectionNameInfo[indexPath.section].itemDetail?[indexPath.row]
            cell2.detailTextLabel?.text = sectionNameInfo[indexPath.section].itemSub?[indexPath.row]
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

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch tableView.tag {
        case 1:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            view.backgroundColor = #colorLiteral(red: 0.9491885304, green: 0.9486994147, blue: 0.9747329354, alpha: 1)
            
            let labelName = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
            labelName.text = sectionNameMeal[section].section
            labelName.textColor = #colorLiteral(red: 0.5178547502, green: 0.5172992349, blue: 0.5433796048, alpha: 1)
            view.addSubview(labelName)
            
            return view
        case 2:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            view.backgroundColor = #colorLiteral(red: 0.9491460919, green: 0.9487624764, blue: 0.9704342484, alpha: 1)
            
            let labelName = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
            labelName.text = sectionNameInfo[section].section2
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

extension EditInputViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "By Ingredients"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
        navigationController?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
}

