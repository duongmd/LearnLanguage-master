//
//  Recorder.swift
//  Language
//
//  Created by PIRATE on 11/15/16.
//  Copyright © 2016 PIRATE. All rights reserved.
//

import UIKit

class Recorder: BaseMediaViewController {

    @IBOutlet weak var tbvRecorder: UITableView!
    var languageID: Int!
    let database = DataBase.sharedInstance
    var dbRecord = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let CellRecorder = UINib(nibName: "CellRecorder", bundle: nil)
        tbvRecorder.register(CellRecorder, forCellReuseIdentifier: "cellRecorder")
        
        tranparentNavigation = false
        
        setBarButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDataWord("WHERE LanguageID = \( languageID! )")
    }
    
    func getDataWord(_ statement: String) {
        dbRecord.removeAll()
        dbRecord = database.viewDatabase("Record", columns: ["*"], statement: statement)
        self.tbvRecorder.reloadData()
    }
    
    
    func setBarButton(){
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "Plus"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(addRecorder), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
        let back = UIButton(type: .custom)
        back.setImage(UIImage(named: "Back-48"),for: .normal)
        back.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        back.addTarget(self, action: #selector(finished), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: back)
        self.navigationItem.setLeftBarButtonItems([item2], animated: true)
    }

    
    func finished()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addRecorder() {
        let addRecorder = ViewAddRecorder(nibName: "ViewAddRecorder", bundle: nil)
        addRecorder.languageID = languageID
        self.navigationController?.pushViewController(addRecorder, animated: true)
    }

    func deleteDB(_ id: Int){
        let item = dbRecord[id]
        database.deleteDatabase("Record", ID: ((item["ID"] as? Int)!))
        dbRecord.remove(at: id)
        
        let soundURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(item["RecordName"]!).m4a")
        
        do {
            try FileManager.default.removeItem(at: soundURL)

        } catch let err as NSError {
            print(err.localizedDescription)
        }
    }
    
}


extension Recorder: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dbRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tbvRecorder.dequeueReusableCell(withIdentifier: "cellRecorder", for: indexPath) as! CellRecorder
        let item = dbRecord[(indexPath as NSIndexPath).row] as! [String:Any]
        cell.textLabel?.text = "\(item["RecordName"] as! String)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDB(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
}
