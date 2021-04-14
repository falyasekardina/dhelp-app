//
//  HomeViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 01/04/21.
//

import UIKit
import CoreData

let currentDate = Date()

class HomeViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var intakes: [Intake]!
    
    var totalSugar = 0.0 // for progress bar calculation
    var dob = ""
    var sex = ""
    var height = ""
    var weight = ""
    var act = ""
    
    var kalori : Float = 0
    var gula : Float = 0
    
    // Data
    var dailyInTakes: [DailyInTake] = [
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
    
    @IBOutlet weak var lblKalori: UILabel!
    @IBOutlet weak var lblGula: UILabel!
    @IBOutlet weak var lblAlert: UILabel!
    
    @IBOutlet weak var totalSugarProgressBar: UIProgressView!
    @IBOutlet weak var totalSugarConsumsionlbl: UILabel!
    
    @IBOutlet weak var totalKaloriProgressBar: UIProgressView!
    @IBOutlet weak var totalKaloriLabel: UILabel!
    
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
        
        itungKeperluan()
        
        let defaults = UserDefaults.standard
        let gula = defaults.object(forKey: "dataGula")
        let kalori = defaults.object(forKey: "dataKalori")
        
        
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
        fetchData()
        
        totalSugarProgressBar.progress = 0.0
        totalKaloriProgressBar.progress = 0.0
        
        //alertView.isHidden = true
    }
    
    func itungKeperluan(){
        let defaults = UserDefaults.standard
        dob = defaults.object(forKey: "dataDob") as! String
        sex = defaults.object(forKey: "dataGender") as! String
        height = defaults.object(forKey: "dataHeight") as! String
        weight = defaults.object(forKey: "dataWeight") as! String
        act = defaults.object(forKey: "dataAct") as! String
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM dd, yyyy"
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .long
        let tanggalSekarang = dateFormater.string(from: Date())
        
        let startDate = dateFormater.date(from: dob)
        let endDate = dateFormater.date(from: tanggalSekarang)
        var diff = Calendar.current.dateComponents([.year], from: startDate!, to: endDate!).year
        
        
        
        if diff! >= 0 && diff! <= 6{
            gula = 19
        }else if diff! >= 7 && diff! <= 10{
            gula = 24
        }else if diff! >= 11 && diff! <= 12{
            gula = 30
        }else if(diff! > 12){
            gula = 50
        }
        
        defaults.setValue(gula, forKey: "dataGula")
        print(gula)
        
        let tb = Float(height)!
        let tbMeter = tb/100
        let pow = tbMeter * tbMeter
        var a : Float = 0
        var b : Float = 0
        
        switch sex {
        case "Male":
            a = pow * 22.5
            b = 30
        case "Female":
            a = pow * 21
            b = 25
        default:
            return
        }
        
        let c = a * b
        var d : Float = 0
        
        if act == "Sedentary (Never/Rarely Exercise)"{
            d = 20/100
        }else if act == "Moderately (Exercise 1-2x / Week)"{
            d = 30 / 100
        }else if act == "Vigorously (Exercise 3-5x / Week)"{
            d = 40 / 100
        }else if act == "Extremely Exercise (6-7x / Week)"{
            d = 50 / 100
        }
        
        let e = c * d
        let f : Float = 10 / 100
        let g = c * f
        var h : Float = 0
        
        if diff! < 40{
            h = 0 / 100
        }else if diff! >= 40 && diff! <= 50{
            h = 5 / 100
        }else if diff! >= 51 && diff! <= 60{
            h = 10 / 100
        }else if diff! >= 61 && diff! <= 70{
            h = 15 / 100
        }else if diff! >= 71 && diff! <= 80{
            h = 20 / 100
        }else if diff! >= 81 && diff! <= 90{
            h = 25 / 100
        }
        
        let i = c * h
        kalori = c + e + g - i
        print(kalori)
        defaults.setValue(Int(kalori), forKey: "dataKalori")
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
    
    func fetchData() {
        do {
            itungKeperluan()
            
            lblGula.text = "\(gula) gr"
            lblKalori.text = "\(Int(kalori)) kcal"
            
            let request = Intake.fetchRequest() as NSFetchRequest<Intake>
            self.intakes = try context.fetch(request)
            //sugar
            var sugarLevelA = 0.0
            var sugarLevelB = 0.0
            var sugarLevelC = 0.0
            var sugarLevelD = 0.0
            
            //kalori
            var kaloriA = 0
            var kaloriB = 0
            var kaloriC = 0
            var kaloriD = 0
            
            
            for dt in self.intakes {
                
                if dt.mealtime == "Breakfast" && getDayFormater(dateData: dt.createdat!) == getDayFormater(dateData: currentDate) {
                    sugarLevelA += dt.sugar
                    kaloriA += Int(dt.calories)
                } else if dt.mealtime == "Lunch" && getDayFormater(dateData: dt.createdat!) == getDayFormater(dateData: currentDate) {
                    sugarLevelB += dt.sugar
                    kaloriB += Int(dt.calories)
                } else if dt.mealtime == "Dinner" && getDayFormater(dateData: dt.createdat!) == getDayFormater(dateData: currentDate) {
                    sugarLevelC += dt.sugar
                    kaloriC += Int(dt.calories)
                } else if dt.mealtime == "Snack" && getDayFormater(dateData: dt.createdat!) == getDayFormater(dateData: currentDate) {
                    sugarLevelD += dt.sugar
                    kaloriD += Int(dt.calories)
                }
            }
            
            //sugar
            self.dailyInTakes[0].total = "\(String(format: "%.1f", sugarLevelA)) gr"
            self.dailyInTakes[1].total = "\(String(format: "%.1f", sugarLevelB)) gr"
            self.dailyInTakes[2].total = "\(String(format: "%.1f", sugarLevelC)) gr"
            self.dailyInTakes[3].total = "\(String(format: "%.1f", sugarLevelD)) gr"
            
            //kalori
            
            // Update Progress bar Value
            let pembagian1 = 1 / gula
            
            let sugarBarTotal = Float(sugarLevelA + sugarLevelB + sugarLevelC + sugarLevelD) * pembagian1
            
            if sugarBarTotal != totalSugarProgressBar.progress {
                totalSugarProgressBar.progress = sugarBarTotal
                print("\(sugarBarTotal)")
                if sugarBarTotal >= 0.80 && sugarBarTotal < 0.99{
                    alertView.isHidden = false
                    lblAlert.text = "Sugar consumption is almost over the limit"
                    totalSugarProgressBar.progressTintColor = #colorLiteral(red: 0.00911075063, green: 0.4539698958, blue: 0.4588753581, alpha: 1)
                }else if sugarBarTotal >= 1{
                    alertView.isHidden = false
                    lblAlert.text = "Sugar consumption has reached the limit"
                    totalSugarProgressBar.progressTintColor = #colorLiteral(red: 1, green: 0.4610788226, blue: 0.4808561206, alpha: 1)
                }else if sugarBarTotal < 0.8{
                    alertView.isHidden = true
                    totalSugarProgressBar.progressTintColor = #colorLiteral(red: 0, green: 0.4552916884, blue: 0.4594951868, alpha: 1)
                }
            }
            
            totalSugarConsumsionlbl.text = "\(String(format: "%.1f", (sugarLevelA + sugarLevelB + sugarLevelC + sugarLevelD))) gr"
            
            print("\(kaloriA + kaloriB + kaloriC + kaloriD)")
            // Kalori
            let pembagian2 = 1 / kalori
            print("\(pembagian2) ini hasil pembagian2")
            
            let kaloriBarTotal = Float(kaloriA + kaloriB + kaloriC + kaloriD) * pembagian2
            print("\(kaloriBarTotal) ini kalori bar total")
            
            print("\(Float(kaloriA + kaloriB + kaloriC + kaloriD))")
            
            if kaloriBarTotal != totalKaloriProgressBar.progress{
                totalKaloriProgressBar.progress = kaloriBarTotal
            }
            
            totalKaloriLabel.text = "\(String(format: "%.f", (Float(kaloriA + kaloriB + kaloriC + kaloriD)))) kcal"
            collectionView.reloadData()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getDayFormater(dateData: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let newFormat = dateFormater.string(from: dateData)
        return newFormat
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
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
        
        if let destinationVCSec = segue.destination as? ByIngTableViewController {
            destinationVCSec.delegate = self
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

protocol HomeTransitionDelegate {
    func moveToHomePage(controller: UIViewController, type: String)
}

extension HomeViewController: HomeTransitionDelegate {
    func moveToHomePage(controller: UIViewController, type: String) {
        navigationController?.popToRootViewController(animated: true)
        self.performSegue(withIdentifier: "ListInputMeal", sender: type)
    }
}
