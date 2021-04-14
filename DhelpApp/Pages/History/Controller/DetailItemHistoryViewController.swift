//
//  DetailItemHistoryViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 13/04/21.
//

import UIKit

class DetailItemHistoryViewController: UIViewController {
    
    var getIntake: Intake?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var carbsLbl: UILabel!
    @IBOutlet weak var sugarLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        caloriesLbl.text = "\(getIntake!.calories) kcal"
        carbsLbl.text = "\(getIntake!.carbs) gr"
        sugarLbl.text = "\(getIntake!.sugar) gr"
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension DetailItemHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = getIntake!.name
        cell.detailTextLabel?.text = getIntake!.manualsize == "" ? "\(getIntake!.servingsize) gr" : getIntake!.manualsize
        
        return cell
    }
    
}
