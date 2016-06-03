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
class RootViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate {

    var _mapView:MAMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //界面
    func viewSetup(){
        initMapView()
    }
    
    func initMapView(){
        _mapView = MAMapView(frame: CGRectMake(0, 65, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-65))
        _mapView.showsUserLocation = true
        _mapView.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        _mapView.showsCompass = false
        //_mapView.showsScale = true
        _mapView.scaleOrigin = CGPointMake(100, _mapView.frame.size.height-20)
        _mapView.delegate = self
        self.view.addSubview(_mapView)
    }

}
