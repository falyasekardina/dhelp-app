//
//  HomeViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 01/04/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Data
    let dailyInTakes: [DailyInTake] = [
        DailyInTake(title: "Breakfast", mealLogo: UIImage(named: "breakfast")!, total: "0gr"),
        DailyInTake(title: "Lunch", mealLogo: UIImage(named: "lunch")!, total: "0gr"),
        DailyInTake(title: "Dinner", mealLogo: UIImage(named: "dinner")!, total: "0gr"),
        DailyInTake(title: "Snack", mealLogo: UIImage(named: "snack")!, total: "0gr")
    ]

    // Component
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func addBtn(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Please choose your input preferences", preferredStyle: .actionSheet)
        let byIngredients = UIAlertAction(title: "By Ingredient", style: .default) { action in
            self.performSegue(withIdentifier: "goToIngredients", sender: self)
        }
        let manualInput = UIAlertAction(title: "Manual Input", style: .default) { action in
            self.performSegue(withIdentifier: "goToManual", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(byIngredients)
        optionMenu.addAction(manualInput)
        optionMenu.addAction(cancelAction)
        optionMenu.view.addSubview(UIView())
        self.present(optionMenu, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupInformationView()
        setupAlertView()
        dateLbl.text = getCurrentDate()
        // Do any additional setup after loading the view.
        
        // CollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewLayout()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getCurrentDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM dd, yyyy"
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .long
        let currentDate = dateFormater.string(from: Date())
        return currentDate
    }
    
    func setupInformationView() {
        informationView.layer.cornerRadius = 20
        informationView.layer.shadowColor = UIColor.black.cgColor
        informationView.layer.shadowOpacity = 1
        informationView.layer.masksToBounds = false
        informationView.layer.shadowOffset = CGSize(width: 0, height: 2)
        informationView.layer.shadowRadius = 3
    }
    
    func setupAlertView() {
        alertView.layer.cornerRadius = 10
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyInTakes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyIntakeType", for: indexPath) as! DailyIntakeTypeCollectionViewCell
        setupCollectionViewCellLayout(cell: cell)
        cell.setup(with: dailyInTakes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ListInputMeal", sender: dailyInTakes[indexPath.row].title)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ListInputMealViewController {
            guard let ingredient = sender as? String else {
                return
            }
            destinationVC.getTitle = ingredient
        }
    }
    
    func setupCollectionViewCellLayout(cell: UICollectionViewCell)
    {
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 2
    }
    
}
