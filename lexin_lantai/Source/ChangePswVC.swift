//
//  ChangePswVC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/6/12.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class ChangePswVC: UIViewController {
    let coreDataDB = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var psdItems      = [Recent]()   //数据库中读取的内容
    @IBOutlet weak var PSWVIEW: SetPassWordView!
    override func viewDidLoad() {
        super.viewDidLoad()

        psdItems = Recent.fetchAll(coreDataDB)
        print("psdItems: \(psdItems)")
        
        
        PSWVIEW.doneAction = {(text) -> () in
            print(text)
            let new  = Recent(name: text, inManagedObjectContext: self.coreDataDB)
            self.psdItems.append(new)
            new.save(self.coreDataDB)// CoreData save
            self.showWarningAlert(text)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showWarningAlert(psw:String){
        let alertcontroller = UIAlertController(title: "您的密码是:\(psw)\n请妥善保管！", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "好的", style: .Default,
            handler: {
                action in
                //                print("点击了确定")
        })
        alertcontroller.addAction(okAction)
        self.presentViewController(alertcontroller, animated: true, completion: { () -> Void in
            
        })
    }
    
}