//
//  HistoryViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 01/04/21.
//

import UIKit

class HistoryViewController: UIViewController {
  
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var pickMonth: UITextField!
    
    let monthPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTable.delegate = self
        historyTable.dataSource = self
        
        createMonthPicker()
    }
    
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
        
        pickMonth.text = pickMonthFormat.string(from: monthPicker.date)
        
        view.endEditing(true)
    }
    
}
    
extension HistoryViewController: UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("history detail")
    }
}

    
extension HistoryViewController: UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Hellow"
        cell.detailTextLabel?.text = "gram gram"
        
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
}






