//
//  HistoryViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 01/04/21.
//

import UIKit

class HistoryViewController: UIViewController {
  
    @IBOutlet weak var historyTable: UITableView!
    
    func navigationController?.navigationBar.barTintColor = UIColor.green
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTable.delegate = self
        historyTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "SUGAR LEVEL CONSUMED PER MONTH"
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
        
        return cell
    }
}



