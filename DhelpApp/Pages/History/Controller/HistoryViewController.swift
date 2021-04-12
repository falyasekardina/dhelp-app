//
//  HistoryViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 01/04/21.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var intakes: [DataHistory]?
    
    var selectedMonth : String?
    
    //    let date1 = generateDates(dates: "2020-08-21")
    
    //    var month : [DataTanggal] = []
    
    @IBOutlet weak var detailHistoryCell: UITableViewCell!
    
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var pickMonth: UITextField!
    
    let monthPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.tableFooterView = UIView(frame: .zero)
        
        createMonthPicker()
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let destination = UI(title: "detailHistory", style: .default) { action in
    //            self.performSegue(withIdentifier: "", sender: self)
    //        }
    //    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "SUGAR LEVEL CONSUMED PER MONTH"
    }
    
    func createMonthPicker(){
        
        pickMonth.textAlignment = .center
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let monthPicker = UIDatePicker.init(frame:CGRect(x:0,y:0,width: self.view.bounds.width, height: 100))
        
        
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickDone))
        
        
        toolbar.setItems([buttonDone], animated: true)
        
        pickMonth.inputAccessoryView = toolbar
        
        pickMonth.inputView = monthPicker
        
        monthPicker.datePickerMode = .date
        
        monthPicker.preferredDatePickerStyle = .wheels
        
    }
    
    
    
    @objc func pickDone(){
        self.intakes = [DataHistory]()
        let choosedMonth = getFormater(dateData: monthPicker.date, month: true)
        let choosedYear = getFormater(dateData: monthPicker.date, month: false)
        
        let pickMonthFormat = DateFormatter()
        
        pickMonthFormat.dateFormat = "MMMM, yyyy"
        
        selectedMonth = pickMonthFormat.string(from: monthPicker.date) // Picker Selected Not Working, just choose current date
        pickMonth.text = pickMonthFormat.string(from: monthPicker.date)
        
//        do {
//            let request = Intake.fetchRequest() as NSFetchRequest<Intake>
//            let mealData = try context.fetch(request)
//            for dt in mealData {
//                if getFormater(dateData: dt.createdat!, month: true) == choosedMonth && getFormater(dateData: dt.createdat!, month: false) == choosedYear {
//                    self.intakes?.append(dt)
//                }
//            }
//
//            DispatchQueue.main.async {
//                self.historyTable.reloadData()
//            }
//        } catch {
//            print("Error: \(error)")
//        }
        
        self.view.endEditing(true)
    }
    
    func fetchData() {
        var keyArray:[String] = []
        self.intakes = [DataHistory]()
        DispatchQueue.main.async {
            do {
                let request = Intake.fetchRequest() as NSFetchRequest<Intake>
                let data = try self.context.fetch(request)
                for dt in data {
                    var checkdate = self.getDayFormater(dateData: dt.createdat!)
                    var totalSugarLevel = 0.0
                    var totalCal = 0
                    var totalCarbs = 0.0
                    if keyArray.count == 0 || keyArray.contains(checkdate) == false {
                        for i in 0...data.count - 1 {
                            if self.getDayFormater(dateData: data[i].createdat!) == checkdate {
                                totalSugarLevel += data[i].sugar
                                totalCal += Int(data[i].calories)
                                totalCarbs += data[i].carbs
                            }
                        }

                        let newData = DataHistory(dates: dt.createdat ?? Date(), totalSugar: totalSugarLevel, totalCal: totalCal, totalCarbs: totalCarbs)
                        keyArray.append(checkdate)
                        self.intakes?.append(newData)
                    }
                    checkdate = ""
                }
                self.historyTable.reloadData()
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

extension HistoryViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailHistory", sender: self)
    }
}


extension HistoryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intakes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(String(describing: dateFormater(dateData: self.intakes?[indexPath.row].dates ?? Date())))"
        cell.detailTextLabel?.text = "\(String(describing: self.intakes![indexPath.row].totalSugar)) gr"
        
        return cell
    }
}


extension HistoryViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
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
    
    func dateFormater(dateData: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM, yyyy"
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .medium
        dateFormater.timeZone = TimeZone.current
        let newFormat = dateFormater.string(from: dateData)
        return newFormat
    }
    
    func getFormater(dateData: Date, month: Bool) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = month ? "MMMM" : "yyyy"
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

struct DataTanggal {
    let dates : Date
    let size : String
}

struct DataHistory {
    let dates: Date
    let totalSugar: Double
    let totalCal: Int
    let totalCarbs: Double
}







//
//                for dt in data {
//                    var checkingDate = self.getDayFormater(dateData: dt.createdat!)
//                    if keyArray.count == 0 {
//                        keyArray.append(checkingDate)
//                        for i in 0...data.count - 1 {
//                            if self.getDayFormater(dateData: data[i].createdat!) == checkingDate {
//                                if self.intakes?.count == 0 || self.getDayFormater(dateData: self.intakes![self.intakes!.count - 1].createdat!) != checkingDate {
//                                    self.intakes!.append(dt)
//                                } else if self.getDayFormater(dateData: self.intakes![self.intakes!.count - 1].createdat!) == checkingDate {
//                                    self.intakes![self.intakes!.count - 1].sugar += data[i].sugar
//                                }
//                            }
//                        }
//                    } else if keyArray.contains(checkingDate) == false {
//                        for i in 0...data.count - 1 {
//                            if self.getDayFormater(dateData: data[i].createdat!) == checkingDate {
//                                if self.intakes?.count == 0 || self.getDayFormater(dateData: self.intakes![self.intakes!.count - 1].createdat!) != checkingDate {
//                                    self.intakes!.append(dt)
//                                } else if self.getDayFormater(dateData: self.intakes![self.intakes!.count - 1].createdat!) == checkingDate {
//                                    self.intakes![self.intakes!.count - 1].sugar += data[i].sugar
//                                }
//                            }
//                        }
//                    }
//                    checkingDate = ""
//                }


//
//self.intakes?.append(dt)
//keyArray.append(checkdate)
//var firstSugar = self.intakes![self.intakes!.count - 1].sugar
//
//for i in 0...data.count - 1 {
//    self.intakes![self.intakes!.count - 1].sugar += data[i].sugar
//}
//if self.intakes![self.intakes!.count - 1].sugar != firstSugar {
//    self.intakes![self.intakes!.count - 1].sugar -= firstSugar
//}
//firstSugar = 0.0
