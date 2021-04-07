//
//  ByManViewController.swift
//  DhelpApp
//
//  Created by Falya Aqiela Sekardina on 07/04/21.
//

import UIKit

class ByManViewController: UIViewController {
    
    @IBOutlet weak var addFoodTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addFoodTable.delegate = self
        addFoodTable.dataSource = self

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

extension ByManViewController: UITableViewDelegate, UITableViewDataSource {
    struct ListOfFields {
        static var fieldName = [
            "Food Name",
            "Calories",
            "Carbs",
            "Sugar",
            "Serving Size"
        ]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionIndex : Int = 0
        if section == 0
        {
            sectionIndex = 1
        }
        else if section == 1
        {
            sectionIndex = 5
        }
        else if section == 2
        {
            sectionIndex = 2
        }
        return sectionIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellTime = tableView.dequeueReusableCell(withIdentifier: "time", for: indexPath)
            cellTime.textLabel?.text = "Time"
            
            return cellTime
        }
        
        else if indexPath.section == 1 {
            let cellDetail = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
            cellDetail.textLabel?.text = ListOfFields.fieldName[indexPath.row]
            
            return cellDetail
        }
        
        return UITableViewCell()
        
    }
    
    private func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            var headerTitle : String?
            if section == 0
            {
                headerTitle = "Time"
            }
            if section == 1
            {
                headerTitle = "Detail"
            }
            return headerTitle
        }

    //Below method wil return number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
}
