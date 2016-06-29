//
//  RootViewController.swift
//  ShowMe
//
//  Created by lulu on 16/6/3.
//  Copyright © 2016年 HandsomeHedgehog. All rights reserved.
//

import UIKit

//高德地图的Appkey
let APIKEY = "cd6b7e0d16e8dc351818bd3446dd98a7"

/****************************
 1.构造MAMapView对象；

 2.设置代理；

 3.将MAMapView添加到Subview中。
*******************************/
class RootViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate {

    var mapView:MAMapView?
    var centerCoordinate:CLLocationCoordinate2D!
    var isRecording: Bool = false
    var locationButton: UIButton?
    var searchButton: UIButton?
    var imageShare: UIImage?
    var search: AMapSearchAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AMapServices.sharedServices().apiKey = APIKEY
        viewSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //界面
    func viewSetup(){
        initMapView1()
        initToolBar()
        
        if centerCoordinate != nil {
            mapView!.setCenterCoordinate(centerCoordinate, animated: true)
            
            let macircle = MACircle.init(centerCoordinate: centerCoordinate, radius: 200.0)
            mapView!.addAnnotation(macircle)
        }
    }
    
    //初始化地图页面
    func initMapView(){
        
        mapView = MAMapView(frame: CGRectMake(0, 65, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-65))
        mapView!.showsUserLocation = true
        mapView!.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        mapView!.showsCompass = false
        //mapView!.showsScale = true
        mapView!.scaleOrigin = CGPointMake(100, mapView!.frame.size.height-20)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
    }
    
    func initMapView1(){
        mapView = MAMapView(frame: self.view.bounds)
        
        mapView!.delegate = self
        
        
//        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 40.078537, longitude: 116.5871)
//        let macircle = MACircle.init(centerCoordinate: coordinate, radius: 200.0)
//        mapView!.addAnnotation(macircle)
        
        self.view.addSubview(mapView!)
        
        let compassX = mapView?.compassOrigin.x
        
        let scaleX = mapView?.scaleOrigin.x
        
        //设置指南针和比例尺的位置
        mapView?.compassOrigin = CGPointMake(compassX!, 21)
        
        mapView?.scaleOrigin = CGPointMake(scaleX!, 21)
        
        // 开启定位
        mapView!.showsUserLocation = true
        
        // 设置跟随定位模式，将定位点设置成地图中心点
    mapView!.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        mapView!.distanceFilter = 10.0
        mapView!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        mapView!.setZoomLevel(10.1, animated: true)
    }
    
    
    func initToolBar() {
        
        let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_list.png"), style: UIBarButtonItemStyle.Bordered, target: self, action: "actionHistory")
        
        navigationItem.rightBarButtonItem = rightButtonItem
        
        let leftButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_play.png"), style: UIBarButtonItemStyle.Bordered, target: self, action: "actionRecordAndStop")
        
        navigationItem.leftBarButtonItem = leftButtonItem
        
        imageShare = UIImage(named: "location_share@2x.png")
        
        locationButton = UIButton(frame: CGRectMake(CGRectGetWidth(view.bounds) - 80, CGRectGetHeight(view.bounds) - 120, 60, 60))
//        locationButton!.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin
        locationButton!.backgroundColor = UIColor.whiteColor()
        locationButton!.layer.cornerRadius = 5
        locationButton!.layer.shadowColor = UIColor.blackColor().CGColor
        locationButton!.layer.shadowOffset = CGSizeMake(5, 5)
        locationButton!.layer.shadowRadius = 5
        //locationButton!.tag=mapView!.userLocation.coordinate
        locationButton!.addTarget(self, action: "addPoint:", forControlEvents: UIControlEvents.TouchUpInside)
        locationButton!.setImage(imageShare, forState: UIControlState.Normal)
        
        view.addSubview(locationButton!)
        
    }
    
    func addPoint(sender: UIButton) {
//        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 40.078537, longitude: 116.5871)
        
        
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        //取出当前位置的坐标
        print("latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        centerCoordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        //mapView.showsUserLocation = false;
    }

}
