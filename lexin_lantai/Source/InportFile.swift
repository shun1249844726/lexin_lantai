//
//  InportFile.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/7/28.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class InportFile:UIViewController,UITextViewDelegate {

    @IBOutlet weak var fileText: UITextView!
    @IBAction func inportFileBtnClick(sender: UIButton) {
        //设定路径
        //Home目录
        let mydir1 = NSHomeDirectory() + "/Documents/"
        let url: NSURL = NSURL(fileURLWithPath: mydir1+"LanTaiRoads.geojson")
        //定义可变数据变量
        
           let tempjson = try? NSJSONSerialization.JSONObjectWithData(fileText.text.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments)
            print("tempjson:\(tempjson)")
            if tempjson != nil{
                if NSJSONSerialization.isValidJSONObject(tempjson!){
                    let data = NSMutableData()
                    //向数据对象中添加文本，并制定文字code
                    data.appendData(fileText.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                    //用data写文件
                    data.writeToFile(url.path!, atomically: true)
                    //从url里面读取数据，读取成功则赋予readData对象，读取失败则走else逻辑
                    if let readData = NSData(contentsOfFile: url.path!) {
                        let json = try? NSJSONSerialization.JSONObjectWithData(readData, options:NSJSONReadingOptions.AllowFragments)
                        print("json\(json)")
    
                        RoadsArray = json! as? Array<Dictionary<String, String>>
                        RoadNum = RoadsArray!.count
                        
                        showMessage("导入成功")

                        //如果内容存在 则用readData创建文字列
                        print(RoadNum)
                    } else {
                        //nil的话，输出空
                        print("Null")
                    }
                }
                else{
                    showMessage("格式错误！ 请检查格式是否正确！")
                }
            }
            else{
                showMessage("请检查格式是否正确！")
            }

    }
    func showMessage(message:String){
        let alertController = UIAlertController(title: "提示", message:message , preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileText.delegate = self
        fileText.returnKeyType = UIReturnKeyType.Done
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text ==  "\n"{
            fileText.resignFirstResponder()
            return false
        }
        return true
    }


}
