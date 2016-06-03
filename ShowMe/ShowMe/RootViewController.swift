//
//  RootViewController.swift
//  ShowMe
//
//  Created by lulu on 16/6/3.
//  Copyright © 2016年 HandsomeHedgehog. All rights reserved.
//

import UIKit

//高德地图的Appkey
let APIKEY = ""

/****************************
1.构造MAMapView对象；

2.设置代理；

3.将MAMapView添加到Subview中。
*******************************/
class RootViewController: UIViewController,MAMapViewDelegate {

    var _mapView:MAMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
