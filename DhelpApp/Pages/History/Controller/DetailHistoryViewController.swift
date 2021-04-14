//
//  DetailHistoryViewController.swift
//  DhelpApp
//
//  Created by Graciela gabrielle Angeline on 08/04/21.
//

import UIKit
import CoreData

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
    var full: Intake
}

class DetailHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var dataCalories = ""
    var dataGula = ""
    var dataCarb = ""
    
    var dataHistory: DataHistory?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBOutlet weak var dateDetailHistory: UILabel!
    
    let tableView: UITableView = {
        let Detailtable = UITableView (frame: CGRect(x: 0, y: 135, width: 390, height: 696), style: .grouped)
        
        Detailtable.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        
        return Detailtable
    }()
    
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configure()
        fecthData()
        dataCalories = "\(dataHistory!.totalCal) kcal"
        dataGula = "\(dataHistory!.totalSugar) gr"
        dataCarb = "\(dataHistory!.totalCarbs) gr"
        dateDetailHistory.text = "\(dateFormater(dateData: dataHistory!.dates))"

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomTableViewCell.nib(), forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
//    func configure(){
//        models.append(Section(header: "", list: [
//            .switchCell(model: CustomCell(namaGram: ""))
//        ]))
//
//        models.append(Section(header: "Breakfast", list: [
//            .staticCell(model: DetailHistory(item: "Nasi Putih", gram: ["16 gr"])),
//            .staticCell(model: DetailHistory(item: "Wortel", gram: ["4 gr"])),
//        ]))
//
//        models.append(Section(header: "Lunch", list: [
//            .staticCell(model: DetailHistory(item: "Ayam Goreng", gram: ["30 gr"])),
//            .staticCell(model: DetailHistory(item: "bayam", gram: ["20 gr"])),
//        ]))
//
//        models.append(Section(header: "Dinner", list: [
//            .staticCell(model: DetailHistory(item: "Ayam Goreng", gram: ["30 gr"])),
//            .staticCell(model: DetailHistory(item: "bayam", gram: ["20 gr"])),
//        ]))
//
//        models.append(Section(header: "Snack", list: [
//            .staticCell(model: DetailHistory(item: "Ayam Goreng", gram: ["30 gr"])),
//            .staticCell(model: DetailHistory(item: "bayam", gram: ["20 gr"])),
//        ]))
//    }
    
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
        switch models[indexPath.section].list[indexPath.row] {
        case .staticCell(let model):
            performSegue(withIdentifier: "gotoDetailItem", sender: model.full)
        case .switchCell(let model):
            print(model.namaGram)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailItemHistoryViewController {
            guard let ingredient = sender as? Intake else {
                return
            }
            destinationVC.getIntake = ingredient
        }
    }
    
    func fecthData() {
        do {
            let request = Intake.fetchRequest() as NSFetchRequest<Intake>
            let datas = try context.fetch(request)
            
            var dataBreakfast = [CellType]()
            var dataLunch = [CellType]()
            var dataDinner = [CellType]()
            var dataSnack = [CellType]()
            
            for dt in datas {
                if getDayFormater(dateData: dt.createdat!) == getDayFormater(dateData: dataHistory!.dates) {
                    var newData = CellType.staticCell(model: DetailHistory(item: dt.name!, gram: ["\(dt.sugar) gr"], full: dt))
                    if dt.mealtime == "Breakfast" {
                        dataBreakfast.append(newData)
                    } else if dt.mealtime == "Lunch" {
                        dataLunch.append(newData)
                    } else if dt.mealtime == "Dinner" {
                        dataDinner.append(newData)
                    } else if dt.mealtime == "Snack" {
                        dataSnack.append(newData)
                    }
                }
            }
            models.append(Section(header: "", list: [.switchCell(model: CustomCell(namaGram: ""))]))
            models.append(Section(header: "Breakfast", list: dataBreakfast))
            models.append(Section(header: "Lunch", list: dataLunch))
            models.append(Section(header: "Dinner", list: dataDinner))
            models.append(Section(header: "Snack", list: dataSnack))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func dateFormater(dateData: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM, yyyy"
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .medium
        dateFormater.timeZone = TimeZone.current
        let newFormat = dateFormater.string(from: dateData)
        return newFormat
    }
    
    func getDayFormater(dateData: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let newFormat = dateFormater.string(from: dateData)
        return newFormat
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
