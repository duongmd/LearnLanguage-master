//
//  TestVC.swift
//  LearnLanguage
//
//  Created by iOS Student on 12/23/16.
//  Copyright © 2016 PIRATE. All rights reserved.
//

import UIKit


class TestVC: UIViewController {
    
    let db = DataBase.sharedInstance
    var Dic = [NSDictionary]()
    
    var Arr : [String] = []
    var indexRightButton: Int!
    var str: String!
    
    var time: Int = 0
    var timer = Timer()
    var numberButtonAnswer: [UIButton] = []
    
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Word: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var nextbtn: UIButton!
    @IBOutlet weak var imgAnswer: UIImageView!
    @IBOutlet weak var lbl_Answer: UILabel!
    
    enum btnx: Int {
        case btn1 = 0
        case btn2,btn3,btn4
        
        case lastObject
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberButtonAnswer = [btn1, btn2, btn3, btn4]
        
        alphaEqualZero()
        getData("")
        randomWord()
        animation()
        startTimeDown(11, 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCornorForAllButton([btn1, btn2, btn3, btn4], 8)
        setCornerLabel(lbl_Time, 25)
    }
    
    func setCornorForAllButton(_ arr: [UIButton], _ radius: CGFloat){
        for i in 0...(arr.count-1) {
            arr[i].layer.cornerRadius = radius
        }
    }
    
    func setCornerLabel(_ lbl: UILabel,_ y: CGFloat ){
        lbl.layer.cornerRadius = y
        lbl.clipsToBounds = true
    }
    
    func alphaEqualZero() {
        setAlphaForButton([btn1, btn2, btn3, btn4], alpha: 0)
        imgAnswer.alpha = 0
        lbl_Answer.alpha = 0
    }
    
    func setAlphaForButton(_ arr: [UIButton], alpha: CGFloat){
        for i in 0...(arr.count-1) {
            arr[i].alpha = alpha
        }
    }
    func setBackgroundForButton(_ arr: [UIButton], _ color: UIColor){
        for i in 0...(arr.count-1) {
            arr[i].backgroundColor = color
        }
    }
    
    func startTimeDown(_ time: Int, _ timeinterval: Double){
        timer.invalidate()
        self.time = time
        timer = Timer.scheduledTimer(timeInterval: timeinterval, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
    }
    
    func countDown(){
        time = time - 1
        lbl_Time.text = String(time)
        if time == 0 {
            timer.invalidate()
            enableButton(false)
            chooseAnswerWrong()
        }
    }
    
    func chooseAnswerWrong(){
        let alpha:CGFloat = 0.3
        
        for i in 1...(numberButtonAnswer.count) {
            if i != indexRightButton {
                setAlphaForButton([numberButtonAnswer[i-1]], alpha: alpha)
                enableButton(false)
            }
            else
            {
                setBackgroundForButton([numberButtonAnswer[i-1]], UIColor.red)
                enableButton(false)
            }
        }
    }
    
    func animation(){
        animateBtn(btn1, 0.0)
        animateBtn(btn2, 0.3)
        animateBtn(btn3, 0.6)
        animateBtn(btn4, 0.9)
    }
    func animateBtn(_ btn: UIButton, _ a: Double){
        UIView.animate(withDuration: 2, delay: a, options: .curveEaseInOut, animations: {
            btn.alpha = 1
            }, completion: nil)
    }
    
    
    func getData(_ statement: String) {
        Dic.removeAll()
        Dic = db.viewDatabase("WORD", columns: ["NameWord","Mean"], statement: statement)
        
        //    print(Dic)
        
    }
    
    
    
    @IBAction func btn1_action(_ sender: UIButton) {
        let numberTag = sender.tag-100
        
        if sender.titleLabel?.text == str! {
            
            sender.backgroundColor = UIColor.red
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                sender.bounds = CGRect(x: self.btn1.bounds.origin.x, y: self.btn1.bounds.origin.y, width: self.btn1.bounds.size.width + 30, height: self.btn1.bounds.size.height)
                
                self.enableButton(false)
                
                for i in 1...(self.numberButtonAnswer.count) {
                    if i != numberTag {
                        self.setAlphaForButton([self.numberButtonAnswer[i-1]], alpha: 0.3)
                    }
                }
                }, completion: nil)
            
            self.exact()
        } else {
            chooseAnswerWrong()
            self.wrong()
        }
        timer.invalidate()
    }
    
    func exact(){
        imgAnswer.image = UIImage(named: "smiley-star")
        imgAnswer.alpha = 1
        lbl_Answer.text = "Exact!"
        lbl_Answer.alpha = 1
    }
    func wrong(){
        imgAnswer.image = UIImage(named: "Sad_Emoticon.png")
        imgAnswer.alpha = 1
        lbl_Answer.text = "Wrong!"
        lbl_Answer.alpha = 1
    }
    
    
    func randomWord(){
        
        let i = Int(arc4random_uniform(UInt32(Dic.count)))
        lbl_Word.text = Dic[i]["NameWord"] as? String
        str = Dic[i]["Mean"] as! String
        
        Dic.remove(at: i)
        Arr.removeAll()
        
        for a in 0...Dic.count-1 {
            let str1 = Dic[a].value(forKey: "Mean") as! String
            if Arr.contains(str1) {
            }else {
                Arr.append(str1)
            }
        }
        
        let randomNum  = arc4random_uniform(UInt32(btnx.lastObject.rawValue))
        if let btn = btnx(rawValue: Int(randomNum)) {
            switch btn {
            case .btn1:         setTitleForAllButton(btnRight: btn1, arrBtnWrong: [btn2,btn3,btn4])
            case .btn2:         setTitleForAllButton(btnRight: btn2, arrBtnWrong: [btn1,btn3,btn4])
            case .btn3:         setTitleForAllButton(btnRight: btn3, arrBtnWrong: [btn1,btn2,btn4])
            case .btn4:         setTitleForAllButton(btnRight: btn4, arrBtnWrong: [btn1,btn2,btn3])
            default : break
            }
        }
        
        indexRightButton = Int(randomNum)+1    //indexRightButton = 1,2,3,4
    }
    
    func getArrAnswer() -> [String] {
        var arrAnswer:[String] = []
        for _ in 1...numberButtonAnswer.count-1 {
            let j = Int(arc4random_uniform(UInt32(Arr.count)))
            arrAnswer.append(Arr[j])
            Arr.remove(at: j)
        }
        return arrAnswer
    }
    
    func setTitleForAllButton(btnRight: UIButton, arrBtnWrong: [UIButton] ){
        let arrAnswer = getArrAnswer()
        print(arrAnswer)
        btnRight.setTitle("\(str!)", for: .normal)
        for i in 1...arrAnswer.count {
            arrBtnWrong[i-1].setTitle("\(arrAnswer[i-1])", for: .normal)
        }
    }
    
    func resetButton(){
        enableButton(true)
        
        for i in 1...numberButtonAnswer.count {
            if i == indexRightButton {
                let btnAnswer = numberButtonAnswer[i-1]
                setBtnOrigin(btnAnswer)
            }
        }
    }
    
    func setBtnOrigin(_ btn: UIButton){
        btn.backgroundColor = UIColor.black
        btn.frame.size.width = 254
        btn.frame.size.height = 30
        btn.frame.origin.x = 80
        switch btn {
        case btn1:      btn.frame.origin.y = 245
        case btn2:      btn.frame.origin.y = 300
        case btn3:      btn.frame.origin.y = 355
        case btn4:      btn.frame.origin.y = 410
        default:    break
        }
    }
    
    func enableButton(_ para: Bool) {
        for i in 1...numberButtonAnswer.count {
            numberButtonAnswer[i].isEnabled = para
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        resetButton()
        alphaEqualZero()
        getData("")
        randomWord()
        animation()
        startTimeDown(11, 1.0)
    }
    
    
    
}
