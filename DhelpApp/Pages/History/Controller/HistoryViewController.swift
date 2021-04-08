//
//  HistoryViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 01/04/21.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var selectedMonth : String?
    
//    let date1 = generateDates(dates: "2020-08-21")
    
    var month : [DataTanggal] = []
  
    @IBOutlet weak var detailHistoryCell: UITableViewCell!
    
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var pickMonth: UITextField!
    
    let monthPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTable.delegate = self
        historyTable.dataSource = self
        
        createMonthPicker()
        
        let date1 = generateDates(dates: "2020-08-21")
        
        month.append(DataTanggal(dates: date1, size: "40 gr"))
        
        month.append(DataTanggal(dates: generateDates(dates: "2020-08-12"), size: "50 gr"))
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
        
        
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickDone))
        
        
        toolbar.setItems([buttonDone], animated: true)
        
        pickMonth.inputAccessoryView = toolbar
        
        pickMonth.inputView = monthPicker
        
        monthPicker.datePickerMode = .date
        
        monthPicker.preferredDatePickerStyle = .wheels
        
    }
    
  

    @objc func pickDone(){
        let pickMonthFormat = DateFormatter()
        
        pickMonthFormat.dateFormat = "MMMM, yyyy"
        
        selectedMonth = pickMonthFormat.string(from: monthPicker.date)
        
        pickMonth.text = pickMonthFormat.string(from: monthPicker.date)
        
        self.historyTable.reloadData()
        self.view.endEditing(true)
    }
    
    
}
    
extension HistoryViewController: UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("history detail")
        
        self.performSegue(withIdentifier: "detailHistory", sender: self)
    }
}

    
extension HistoryViewController: UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return month.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(month[indexPath.row].dates)"
        cell.detailTextLabel?.text = month[indexPath.row].size
        
        return cell
    }
    
    
}



extension HistoryViewController {
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
    
    func generateDates(dates: String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dates)
            return date ?? Date()
    }
}

struct DataTanggal {
    let dates : Date
    let size : String
    
    
}





