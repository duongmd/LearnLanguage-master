//
//  TableLanguage.swift
//  Learning-Language
//
//  Created by PIRATE on 11/11/16.
//  Copyright © 2016 Duong. All rights reserved.
//

import UIKit



class TableLanguage: UIViewController, UITableViewDataSource, UITableViewDelegate {


    var db = [NSDictionary]()
    @IBOutlet weak var tbvLanguage: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "LANGUAGE"
        setButtonForBarItem()
        
        let nib = UINib(nibName: "Cell", bundle: nil)
        self.tbvLanguage.register(nib, forCellReuseIdentifier: "CellLanguage")
        
        self.tbvLanguage.separatorStyle = .none // xoa dong ke trong tableview
    }
    
//    func customButton() -> UIButton {
//        let menu = UIButton(type: .custom)
//        menu.setImage(UIImage(named: "menu"), for: .normal)
//        menu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        menu.addTarget(self, action: #selector(addLanguage1), for: .touchUpInside)
//        
//        return menu
//    }
    
    func setButtonForBarItem(){
        
//        let item1 = UIBarButtonItem(customView: customButton())
//        self.navigationItem.setLeftBarButton(item1, animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addALanguage))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationBarItem()
        
        let database = DataBase.sharedInstance
        db = database.viewDatabase("LANGUAGE", columns: ["*"], statement: "")
        
        tbvLanguage.reloadData()
    }
    
    func addALanguage() {
        var AddLanguage : addLanguage!
        AddLanguage = addLanguage(nibName: "addLanguage", bundle: nil)
        
        self.navigationController?.pushViewController(AddLanguage, animated: true)
    }
    

    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return db.count
    }
    

    //Animation Cell Table
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.5, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
            },completion: { finished in
                UIView.animate(withDuration: 0.3, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1,1,1.5)
                })
        })
    }
    
    func getPaths() -> [String] {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        return paths
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let cell = tbvLanguage.dequeueReusableCell(withIdentifier: "CellLanguage") as! Cell
        let item = db[indexPath.row] as! [String:Any]
        cell.name.text = item["LanguageName"] as? String
        
        if let dirPath = getPaths().first
        {
            let image = item["LanguageName"] as! String
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(image).png")
            cell.languageimage.image = UIImage(contentsOfFile: imageURL.path)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = StudyVC(nibName: "StudyVC", bundle: nil)
        let item = db[indexPath.row] as! [String:Any]
        
        view.stringtitle = item["LanguageName"] as? String
        view.languageID =  item["ID"] as! Int
        
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alertController = UIAlertController(title: "Are you sure DELETE?", message: "Remove Language", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            })
            alertController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                
                self.deleteDB("WORD", "Language", indexPath.row)
                
                self.db.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            })
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
         
        }
        
    }
    func deleteDB(_ table1: String, _ table2: String, _ id: Int){
        let item = db[id]
        let database = DataBase.sharedInstance
        database.deleteWordDatabase(table1, ID: ((item["ID"] as? Int)! ))
        database.deleteDatabase(table2, ID: ((item["ID"] as? Int)! ))
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}


//extension TableLanguage : SlideMenuControllerDelegate {
//    
//    func leftWillOpen() {
//        print("SlideMenuControllerDelegate: leftWillOpen")
//    }
//    
//    func leftDidOpen() {
//        print("SlideMenuControllerDelegate: leftDidOpen")
//    }
//    
//    func leftWillClose() {
//        print("SlideMenuControllerDelegate: leftWillClose")
//    }
//    
//    func leftDidClose() {
//        print("SlideMenuControllerDelegate: leftDidClose")
//    }
//    
//    func rightWillOpen() {
//        print("SlideMenuControllerDelegate: rightWillOpen")
//    }
//    
//    func rightDidOpen() {
//        print("SlideMenuControllerDelegate: rightDidOpen")
//    }
//    
//    func rightWillClose() {
//        print("SlideMenuControllerDelegate: rightWillClose")
//    }
//    
//    func rightDidClose() {
//        print("SlideMenuControllerDelegate: rightDidClose")
//    }
//}




