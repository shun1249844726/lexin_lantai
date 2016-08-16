//
//  ExcutePlanVC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/3/7.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit
import Foundation

class ExcutePlanVC: UIViewController ,BMKMapViewDelegate{
    var myAddress = "192.168.234.1"
    var myPort = 65317
    @IBOutlet weak var detailsView: UIView!         //详情列表
    @IBOutlet weak var _mapView: BMKMapView!        //
    @IBOutlet weak var nextCrossLable: UILabel!     //下一路口
    @IBOutlet weak var distanceLable: UILabel!      //距离
    @IBOutlet weak var orientationLable: UILabel!   //入口方向
    @IBOutlet weak var taskCrossNumLable: UILabel!  //任务路口
    @IBOutlet weak var leftCrossNumLable: UILabel!  //剩余路口
    @IBOutlet weak var connectStatusLable: UILabel! //连接状态
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
//    var myLongitude = Double(121.08083055555555) //当前定位的经纬度
//    var myLatitude = Double(32.05061388888889)
    
    
    var myLongitude = Double(0) //当前定位的经纬度
    var myLatitude = Double(0)
//    var myLongitude = Double(121.0806) //当前定位的经纬度
//    var myLatitude = Double(32.07202777777778)
    /**
    *   设置详情列表显示还是隐藏
    **/
    @IBOutlet weak var showOrHiddenButttonItem: UIBarButtonItem!
    @IBAction func showOrHiddenBtn(sender: UIBarButtonItem) {
        if detailsView.hidden{
            detailsView.hidden = false
            showOrHiddenButttonItem.title = "隐藏"
        }
        else{
            detailsView.hidden = true
            showOrHiddenButttonItem.title = "显示"
        }
    }
    /**
     *  开始执行方案
     **/
    @IBAction func startBtn(sender: UIButton) {
        
        // 启用计时器，控制每秒执行一次tickDown方法
        timer = NSTimer.scheduledTimerWithTimeInterval(1,target:self,selector:Selector("tickDown"),userInfo:nil,repeats:true)
        startButtonShowOrNot(true)
        
        if self.client != nil{
            self.client.close()
        }
        self.client = TCPClient(addr:myAddress,port: myPort)
        self.client.delegate = self
        self.client.connectServer(timeout: 10)
        
    }
    func startButtonShowOrNot(flag : Bool){
        startButton.enabled = !flag
        stopButton.enabled = flag
        finishButton.enabled = flag
    }
    /**
     *  暂停执行方案
     **/
    @IBAction func stopBtn(sender: UIButton) {
        
        timer.invalidate()
        startButtonShowOrNot(false)
    }
    /**
     *结束执行方案
     **/
    @IBAction func finishBtn(sender: UIButton) {
        startButtonShowOrNot(false)
        
        self.client.close()
        timer.invalidate()
    }


    var pointAnnotation: BMKPointAnnotation?
    var myLocation :BMKPointAnnotation?
    var colorfulPolyline: BMKPolyline?
    var myLocationColorPolyLine : BMKPolyline?
    
    var roadNameArrayList : Array<Dictionary<String, String>> = []    //存储整个路径的各个路口的名称和方向信息
    var roadDetailsArrayList : Array<Dictionary<String, String>> = [] // 路口详情，包括，经纬度、信号机编号、相位方向
    var startCross :Int = 0          //起始路口
    var fleetNum = 0            //车队长度
    var sendCancleDistance = 0 //发送取消控制该路口的命令的距离
    
    var markerTag = 0   //标记物的tag值
    var nowCrossNum = 0 //设置当前的路口的初始值
    var startFlag = 0
    var overFlag = 0
    var gameOverFlag = 0
    var sendOnceFlag = 0
    var sendedRoadNum = 0
    var sendCancleNum = 0
    var comeInRoadFlag = 0
    
    var distanceArray : [Int] = [Int]()
    var time = 0
    var timer:NSTimer!
    var coords :[CLLocationCoordinate2D] = []   //各个标注的坐标
    var distance :Int = 1000000
    var lastDistance :Int = 100000
    
    var communicateSuccess = 0



    var client: TCPClient!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        _mapView.zoomLevel = 15
        sendCancleDistance = ((fleetNum+1)*5)*(FleetLength+FleetSpacing)
        roadDetailsArrayList = getRoadDetails()
        _mapView.centerCoordinate = CLLocationCoordinate2DMake( Double(roadDetailsArrayList[startCross]["Latitude"]!)!,Double(roadDetailsArrayList[startCross]["Longitude"]!)!)
        
        taskCrossNumLable.text = String(roadNameArrayList.count - startCross)
        nextCrossLable.text = roadNameArrayList[startCross]["road"]
        distanceLable.text = String("")
        orientationLable.text = roadNameArrayList[startCross]["orientation"]
        leftCrossNumLable.text = String(roadNameArrayList.count - startCross)
        
        
        self.client = TCPClient(addr:myAddress,port: myPort)
        self.client.delegate = self
    }
    /**
     *计时器每秒触发事件
     **/
    func tickDown()
    {
     //   print("tick...\(time++)")
        client.send(data: GETGPSPACKAGE)
       
        /**静态模拟位置移动，放在解析数据中**/
    //    myLatitude += 0.0001
        let coor = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        //坐标转换，GPS坐标转百度地图坐标
        let testdic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS)
        myLocation?.coordinate = BMKCoorDictionaryDecode(testdic)
        _mapView.removeOverlay(myLocationColorPolyLine)
        updataLine()
        /****/
        

        /*   提前判断后两个路口的距离 */
        let myLocationPoint = BMKMapPointForCoordinate((myLocation?.coordinate)!)
        let nowCrossPoint = BMKMapPointForCoordinate(coords[nowCrossNum])
        distance = Int(BMKMetersBetweenMapPoints(myLocationPoint, nowCrossPoint))
        distanceLable.text = String(distance)  //距离lable 显示

        // 距离上一个路口的距离
        if nowCrossNum >= 1{
            let lastCrossPoint = BMKMapPointForCoordinate(coords[nowCrossNum-1])
            lastDistance = Int(BMKMetersBetweenMapPoints(myLocationPoint, lastCrossPoint))
//            print("lastDistance:\(lastDistance)")
        }
             
        if distance < SendDistance {
            startFlag++
            if startFlag == 1 {
                if sendedRoadNum <= nowCrossNum{
                    ////////////////
                    sendControlRoad(nowCrossNum,controlOrCancle: "on")
               //     print("发送控制:\(roadNameArrayList[startCross + nowCrossNum]["road"])")
                    sendedRoadNum++
                }
            }
            
            var distanceTwo : [Int] = [Int]()
            if nowCrossNum < (roadNameArrayList.count - startCross-2){    //剩余路口数量大于一个
                distanceTwo.append(Int(distance + distanceArray[nowCrossNum]))
                distanceTwo.append(Int(distance + distanceArray[nowCrossNum+1]+distanceArray[nowCrossNum]))
                if distanceTwo[0] < SendDistance {
                    sendOnceFlag++
                    if sendOnceFlag == 1{
                        /////
                        sendControlRoad(nowCrossNum+1,controlOrCancle: "on")
                    //      print("发送控制:\(roadNameArrayList[startCross + nowCrossNum+1]["road"])")
                        sendedRoadNum++
                    }
                }
                if distanceTwo[1] < SendDistance {
                    sendOnceFlag++
                    if sendOnceFlag == 1{
                        /////
                        sendControlRoad(nowCrossNum+2,controlOrCancle: "on")
                     //   print("发送控制:\(roadNameArrayList[startCross + nowCrossNum+2]["road"])")
                        sendedRoadNum++
                    }
                }
            }
            else if nowCrossNum == roadNameArrayList.count - startCross-2{   // 剩余路口数量等于1
                distanceTwo.append(Int(distance + distanceArray[nowCrossNum]))
                if distanceTwo[0] < SendDistance {
                    sendOnceFlag++
                    if sendOnceFlag == 1{
                     //   print("发送控制:\(roadNameArrayList[startCross + nowCrossNum+1]["road"])")

                        sendControlRoad(nowCrossNum+1,controlOrCancle: "on")
                        sendedRoadNum++
                    }
                }
            }
            if distance <= 50{
            
                comeInRoadFlag = 1
            }
            if distance > sendCancleDistance && gameOverFlag == 1{ //结束导航
                
                print("结束导航")
                nextCrossLable.text = "导航结束"
                nextCrossLable.textColor = UIColor.redColor()
                leftCrossNumLable.text = "0"
                distanceLable.text = "0"
                orientationLable.text = ""
                timer.invalidate()
                
            }
            if distance > 50 && comeInRoadFlag == 1{   //进入下一个路口处
                sendOnceFlag = 0
                nowCrossNum++
                if nowCrossNum == roadNameArrayList.count - startCross{
                    nowCrossNum = roadNameArrayList.count - startCross - 1
                    gameOverFlag = 1
                }
                if nowCrossNum < (roadNameArrayList.count-startCross){
                    nextCrossLable.text = roadNameArrayList[startCross+nowCrossNum]["road"]
                    orientationLable.text = roadNameArrayList[startCross+nowCrossNum]["orientation"]
                    leftCrossNumLable.text = String(roadNameArrayList.count-startCross-nowCrossNum)
                    //画线
                    
                    comeInRoadFlag = 0
                    overFlag = 1
                }
            }
            
            if lastDistance > sendCancleDistance && overFlag == 1{
                //发送停止控制
                
                sendCancleRoad(sendCancleNum)
                sendCancleNum++
                overFlag = 0
                startFlag = 0
            }
            
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _mapView.viewWillAppear()
        _mapView.delegate = self
        
        startButtonShowOrNot(false)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView.viewWillDisappear()
        _mapView.delegate = nil
        
        //退出时候释放放行信息
        for index in startCross..<roadNameArrayList.count{
            sendControlRoad(index, controlOrCancle: "off")
        }
        
        
        if timer != nil{
            timer.invalidate()
        }
        if client != nil{
            self.client.close()
        }
        
   }
    /**
    * 画线 ，定位与下个路口之间
    **/
    func updataLine(){
        var mycoords : [CLLocationCoordinate2D] = []
        

        var coor = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        var testdic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS)
        mycoords.append(BMKCoorDictionaryDecode(testdic))
        
        coor =  CLLocationCoordinate2DMake(Double(roadDetailsArrayList[startCross+nowCrossNum]["Latitude"]!)!, Double(roadDetailsArrayList[startCross+nowCrossNum]["Longitude"]!)!)
        testdic =  BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS)
        mycoords.append(BMKCoorDictionaryDecode(testdic))

        
        
            myLocationColorPolyLine = BMKPolyline(coordinates: &mycoords, count: 2, textureIndex: [2])
        _mapView.addOverlay(myLocationColorPolyLine)
    }
    
    /**
     * 画线 ，标注之间的连线
     **/
    
    func addLines(greenNum:Int){
   //     if colorfulPolyline == nil {
            var textureIndex = [Int](count: greenNum+1, repeatedValue: 0)
            
            var longitude :Double = 0.0
            var latitude :Double = 0.0
            let count : UInt = UInt(roadDetailsArrayList.count-startCross)
            
            textureIndex.append(1)
         //   print("textureIndex:\(textureIndex)")

            for index in startCross..<(roadDetailsArrayList.count){
                longitude = Double(roadDetailsArrayList[index]["Longitude"]!)!
                latitude = Double(roadDetailsArrayList[index]["Latitude"]!)!
                
                let coor = CLLocationCoordinate2DMake(latitude, longitude)
                let testdic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS)
                
                coords.append(BMKCoorDictionaryDecode(testdic))
            }
            colorfulPolyline = BMKPolyline(coordinates: &coords, count: count, textureIndex: textureIndex)
            
            //获取几个标注之间的距离
            for index in 0..<Int(count - 1){
                let point1 = BMKMapPointForCoordinate(coords[index])
                let point2 = BMKMapPointForCoordinate(coords[index+1])
                let distance : CLLocationDistance  = BMKMetersBetweenMapPoints(point1, point2)
                distanceArray.append(Int(distance))
            }
//            print("distanceArray:\(distanceArray)")
        //}
        _mapView.addOverlay(colorfulPolyline)
    }
    /**
     *获取路口信息
     **/
    func getRoadDetails() -> Array<Dictionary<String, String>>
    {
        var roadDetails : Array<Dictionary<String,String>> = []
        var oneroadDeatail : [String : String] = ["SignallerId":"","Longitude":"","Latitude":"","PhaseInfo":""]
        for roadNameIndex in roadNameArrayList{
            for roadsArrayIndex in RoadsArray!{
                
                if(roadNameIndex["road"]! == roadsArrayIndex["RoadName"]!){
                    oneroadDeatail["SignallerId"] = roadsArrayIndex["SignallerId"]
                    oneroadDeatail["Longitude"] = roadsArrayIndex["Longitude"]
                    oneroadDeatail["Latitude"] = roadsArrayIndex["Latitude"]
                    oneroadDeatail["PhaseInfo"] = roadsArrayIndex["PhaseInfo"]
                    roadDetails.append(oneroadDeatail)
                }
            }
        }
//        print(roadDetails)
        return roadDetails
    }
    /**
     *添加标注
     **/
    func addPointAnnotation(){
         if pointAnnotation == nil{
            for index in startCross..<roadNameArrayList.count{
            
                markerTag++
                
                let longitude = Double(roadDetailsArrayList[index]["Longitude"]!)
                let latitude = Double(roadDetailsArrayList[index]["Latitude"]!)
                
                let coor = CLLocationCoordinate2DMake(latitude!, longitude!)
                //坐标转换，GPS坐标转百度地图坐标
                let testdic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS)
                
                pointAnnotation = BMKPointAnnotation()
                pointAnnotation?.coordinate = BMKCoorDictionaryDecode(testdic)
                pointAnnotation?.title = roadNameArrayList[index]["road"]

    //            pointAnnotation?.title = markerTitle
                
                _mapView.addAnnotation(pointAnnotation)
            }
        }
        if myLocation == nil{

            let coor = CLLocationCoordinate2DMake(myLatitude, myLongitude)
            //坐标转换，GPS坐标转百度地图坐标
            let testdic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS)
            
            myLocation = BMKPointAnnotation()
            myLocation?.coordinate = BMKCoorDictionaryDecode(testdic)
            
            _mapView.addAnnotation(myLocation)
        }
    }
    /**
     *地图初始化完毕时会调用此接口
     *@param mapview 地图View
     */
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        addPointAnnotation()
        addLines(-1)
        updataLine()
    }
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注Viewh
     */
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let AnnotationViewID = "renameMark"+String(markerTag)
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationViewID) as! BMKPinAnnotationView?
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            annotationView?.tag = markerTag
            // 设置颜色
            //
            if (annotation as! BMKPointAnnotation) == myLocation{
               // annotationView!.pinColor = UInt(BMKPinAnnotationColorGreen)
                annotationView?.image = UIImage(named: "location")
            }
            else{
                annotationView?.image = UIImage(named: "trafficlight")
            }
            // 从天上掉下的动画
            annotationView!.animatesDrop = false
            // 设置是否可以拖拽
            annotationView!.draggable = false
        }
        annotationView?.annotation = annotation
        return annotationView
    }
    /**
    *根据overlay生成对应的View
    *@param mapView 地图View
    *@param overlay 指定的overlay
    *@return 生成的覆盖物View
    */
    func mapView(mapView: BMKMapView!, viewForOverlay overlay: BMKOverlay!) -> BMKOverlayView! {
        if let overlayTemp = overlay as? BMKPolyline {
            let polylineView = BMKPolylineView(overlay: overlay)
            if overlayTemp == colorfulPolyline || overlayTemp == myLocationColorPolyLine{
                polylineView.lineWidth = 5
                /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
                polylineView.colors = [UIColor(red: 0, green: 1, blue: 0, alpha: 1),
                    UIColor(red: 1, green: 0, blue: 0, alpha: 1),
                    UIColor(red: 1, green: 1, blue: 0, alpha: 1)]
            }
            return polylineView
        }
        return nil
    }
    func alert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     *发送控制红绿灯函数
     ＊ 报文格式： 1、包头 ＋ 命令字 ＋ 2、重复次数 ＋ 3、信号机编号 ＋ 4、控制类型 ＋ 5、放行时间 ＋ 6、相位数量 ＋ 7、相位数组 ＋ 8、包尾（CRC + 0x7E）
     * @参数 ： controlOrCancle : on/off
     **/
    func sendControlRoad(nowcrossnum : Int, controlOrCancle:String){

        for _ in 0...7{
            
            let roadname = roadNameArrayList[startCross + nowcrossnum]["road"]!
            
            var controlPackets : [UInt8] = [0x7E,0x40,0x00,0x00,0x00,0x00,0x00,0x06] //1、包头＋ 命令字
            controlPackets.append(0x09)  //2、重复次数
            
            
            for index in getSignallerIdAndToUint8(nowcrossnum){  //3、信号机编号
                controlPackets.append(index)
            }
            if controlOrCancle == "off"{
                controlPackets.append(0x00) // 4、控制类型
                controlPackets.append(0x00) // 5、放行时间
                controlPackets.append(0x00) // 6、相位数量
            }
            else if controlOrCancle == "on"{
                controlPackets.append(0x6C)  // 4、控制类型
                controlPackets.append(0xFF)  // 5、放行时间
                let phaseInfoArray = getPhaseInfoAndToUint8(nowcrossnum) //获取相位数组
                controlPackets.append(UInt8(phaseInfoArray.count))  //6、相位数量
                for index in phaseInfoArray{     //7 、相位数组
                    controlPackets.append(index)
                }
            }
            
            let crc1 = CRC()
            let crcResult = crc1.getCRC16(controlPackets,startIndex: 1,length: controlPackets.count-1)
            controlPackets.append(crcResult)   // CRC 校验
            controlPackets.append(0x7E)   //包尾
            
            client.send(data: controlPackets)    //  打包发送
            var s = ""  //调试使用
            for index in controlPackets{
                s += String(index,radix:16)+" "
            }
            if controlOrCancle == "off"{
                print("取消   \(roadname)：\(s.uppercaseString)")
            }
            else if controlOrCancle == "on"{
                print("控制  \(roadname)：\(s.uppercaseString)")
                
                _mapView.removeOverlay(colorfulPolyline)
                addLines(nowcrossnum)  //更新连线
                
            }
            

        }
    }
    /**
     * 发送取消控制红绿灯函数
     **/
    func sendCancleRoad(sendcanclenum:Int){
        for _ in 0...5{
            sendControlRoad(sendcanclenum, controlOrCancle: "off")
        }

     //   print("发送停止控制红绿灯:\(roadname)")
    }
    
    /**
     * 获取信号机编号
     **/
    func getSignallerIdAndToUint8(nowcrossnum :Int) -> [UInt8]{
        var signallerIndarray : [UInt8] = []
        let SignallerIdString : String =  roadDetailsArrayList[startCross + nowcrossnum]["SignallerId"]!
        for index in 0..<SignallerIdString.characters.count/2{
            signallerIndarray.append(SignallerIdString[index*2...index*2+1].changeToUint8())
        }
  //      print("SignallerIdString:\(SignallerIdString)")
        return signallerIndarray
    }
    
    /**
     * 获取相位数组
     **/
    func getPhaseInfoAndToUint8(nowcrossnum:Int) -> [UInt8]{
        
        var orientation : UInt8 = 0
        switch roadNameArrayList[startCross+nowcrossnum]["orientation"]!{
        case "北":
            orientation = 101
        case "西北":
            orientation = 102
        case "西":
            orientation = 103
        case "西南":
            orientation = 104
        case "南":
            orientation = 105
        case "东南":
            orientation = 106
        case "东":
            orientation = 107
        case "东北":
            orientation = 108
        default :
            break
        }

        let phaseInfoString : String =  roadDetailsArrayList[startCross + nowcrossnum]["PhaseInfo"]!
//        print("phaseInfoString:\(phaseInfoString)")
        let length = phaseInfoString.characters.count
        var phaseInfoArray  = Array<Array<UInt8>>(count: length/12, repeatedValue: Array<UInt8>(count: 4, repeatedValue: 0))   //全部相位编号信息
        var returnedArray = Array<UInt8>()
        for i in 0..<length/12{
            for j in 0..<4{
                let start = i*12+3*j
                let end = i*12+3*j+2
                phaseInfoArray[i][j] = UInt8(phaseInfoString[start...end])!
            }
        }
        for index in phaseInfoArray{
            if index[1] == orientation{
                returnedArray.append(index[0] - 100)  //相位编号，减去100
            }
        }
        
        return returnedArray
    }
}
extension ExcutePlanVC: TCPClientDelegate {
    func client(client: TCPClient, connectSververState state: ClientState) {
        print(state, terminator: "")
        alert("Alert", msg: "connect to server: \(state)")
        connectStatusLable.text = String(state)
    }

    func client(client: TCPClient, receivedData data: NSData) {
        
//        print("data.length:\(data.length)")
        var temp = ""
        for index in 0..<data.length{
            temp += (String(data.byteArray[index],radix:16)+" ").uppercaseString
        }
//        print(temp)
        //解析经纬度信息。在这里获取到myLongitude 和myLatitude
        if data.length == 18 && data.byteArray[17] == 0x7E{
   //         print("getlong and lat:\(getLongitudeAndLatitude(data.byteArray))")
            
            myLongitude = getLongitudeAndLatitude(data.byteArray)[0]
            myLatitude = getLongitudeAndLatitude(data.byteArray)[1]
        }
//        if data.length == 11 {
//            if temp == COMMUNITEERROR{  //通讯精灵返回失败
//                print("data.length:\(data.length)")
//                print(temp)
//            }
//            else{
//            
//            }
//        }
        
//      if let msg = NSString(data: data, encoding: NSUTF8StringEncoding) {
//            dispatch_async(dispatch_get_main_queue()) { () in
//               // self?.receivedMsg.text = "\(self!.serverIP.text!):\(msg)"
//                print("receiveMsg:\(msg)")
//            }
//        }
    }
}

