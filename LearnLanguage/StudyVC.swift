//
//  StudyVC.swift
//  Learning-Language
//
//  Created by iOS Student on 11/11/16.
//  Copyright © 2016 Duong. All rights reserved.
//

import UIKit

class StudyVC: UIViewController {
    
    var stringtitle: String?
    var languageID: Int!
    @IBOutlet weak var btn_word: UIButton!
    @IBOutlet weak var btn_media: UIButton!
    @IBOutlet weak var btn_test: UIButton!
    

    var animator = UIDynamicAnimator()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAlphaForButton(btn_word, 0)
        setAlphaForButton(btn_media, 0)
        setAlphaForButton(btn_test, 0)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCornerButton(btn_word)
        setCornerButton(btn_media)
        setCornerButton(btn_test)
    }
    
    func setAlphaForButton(_ btn: UIButton, _ alpha: CGFloat){
        btn.alpha = alpha
    }
    func setCornerButton(_ btn: UIButton){
        btn.layer.cornerRadius = btn.bounds.size.width/2
        btn.clipsToBounds = true
    }
    

    func animationForButton(_ duration: Double, _ delay: Double, _ btn: UIButton) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.setAlphaForButton(btn, 1)
    }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = stringtitle

        animationForButton(0.5, 0.3, btn_word)
        animationForButton(0.5, 0.3, btn_media)
        animationForButton(0.5, 0.3, btn_test)
    }
    
    
    @IBAction func action_word(_ sender: UIButton) {

        let tabbarWord = WordTabbarController()
        
        tabbarWord.languageid = languageID
        
        transitionStyle(tabbarWord, .flipHorizontal)
    }
    
    @IBAction func action_media(_ sender: UIButton) {
        let tabbarMedia = MediaTabbarController()
        tabbarMedia.languageID = languageID
        
        transitionStyle(tabbarMedia, .coverVertical)
    }
 
    @IBAction func action_test(_ sender: UIButton) {
        let testVC = TestVC(nibName: "TestVC", bundle: nil)

        self.navigationController!.view.layer.add(setAnimate(0.5), forKey: nil)
        navigationController?.pushViewController(testVC, animated: false)
    }
    
    func setAnimate(_ duration: Double) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        
        return transition
    }
    
    func transitionStyle(_ tabbar: UITabBarController, _ style: UIModalTransitionStyle){
        tabbar.modalTransitionStyle = style
        present(tabbar, animated: true, completion: nil)
    }
    
}
