//
//  RootViewController.swift
//  ShowMe
//
//  Created by lulu on 16/6/3.
//  Copyright © 2016年 HandsomeHedgehog. All rights reserved.
//

import UIKit
import Alamofire

//高德地图的Appkey
//let APIKEY = "cd6b7e0d16e8dc351818bd3446dd98a7"

/****************************
 1.构造MAMapView对象；

 2.设置代理；

 3.将MAMapView添加到Subview中。
*******************************/
class RootViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate {

    var mapView:MAMapView!
    var search: AMapSearchAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.isShowsUserLocation=true
        mapView.userTrackingMode=MAUserTrackingMode.follow
    }
    
    //界面
    func viewSetup(){
        initMapView()
//        initToolBar()
        initSearch()
        
    }
    
    
    
    //初始化地图页面
    func initMapView(){
        mapView = MAMapView(frame: self.view.bounds)
        mapView?.isShowsUserLocation=true
        mapView!.setUserTrackingMode(MAUserTrackingMode.follow, animated: true)
        mapView!.delegate = self
        
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 40.078537, longitude: 116.5871)
        let macircle = MACircle.init(center: coordinate, radius: 200.0)
        mapView!.addAnnotation(macircle)
        
        self.view.addSubview(mapView!)
        
        let compassX = mapView?.compassOrigin.x
        
        let scaleX = mapView?.scaleOrigin.x
        
        //设置指南针和比例尺的位置
        mapView?.compassOrigin = CGPoint(x: compassX!, y: 21)
        
        mapView?.scaleOrigin = CGPoint(x: scaleX!, y: 21)
        
        // 开启定位
        mapView!.isShowsUserLocation = true
        
        // 设置跟随定位模式，将定位点设置成地图中心点
    mapView!.setUserTrackingMode(MAUserTrackingMode.follow, animated: true)
        mapView!.distanceFilter = 10.0
        mapView!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        mapView!.setZoomLevel(10.1, animated: true)
    }
    
    
//    func initToolBar() {
//        
//        let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_list.png"), style: UIBarButtonItemStyle.bordered, target: self, action: "actionHistory")
//        
//        navigationItem.rightBarButtonItem = rightButtonItem
//        
//        let leftButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_play.png"), style: UIBarButtonItemStyle.bordered, target: self, action: "actionRecordAndStop")
//        
//        navigationItem.leftBarButtonItem = leftButtonItem
//        
//        imageShare = UIImage(named: "location_share@2x.png")
//        
//        locationButton = UIButton(frame: CGRect(x: view.bounds.width - 80, y: view.bounds.height - 120, width: 60, height: 60))
////        locationButton!.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin
//        locationButton!.backgroundColor = UIColor.white
//        locationButton!.layer.cornerRadius = 5
//        locationButton!.layer.shadowColor = UIColor.black.cgColor
//        locationButton!.layer.shadowOffset = CGSize(width: 5, height: 5)
//        locationButton!.layer.shadowRadius = 5
//        //locationButton!.tag=mapView!.userLocation.coordinate
//        locationButton!.addTarget(self, action: #selector(RootViewController.addPoint(_:)), for: UIControlEvents.touchUpInside)
//        locationButton!.setImage(imageShare, for: UIControlState())
//        
//        view.addSubview(locationButton!)
//        
//    }
    
//    func addPoint(_ sender: UIButton) {
////        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 40.078537, longitude: 116.5871)
//        
//        
//    }
 
    
    func initSearch(){
        search=AMapSearchAPI()
        search.delegate=self
    }
    
    // 发起逆地理编码请求
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        self.search!.aMapReGoecodeSearch(regeo)
    }
    
    //MARK:- MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
        // 长按地图触发回调，在长按点进行逆地理编码查询
        searchReGeocodeWithCoordinate(coordinate: coordinate)
    }
    
    //MARK:- AMapSearchDelegate
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("request :\(request), error: \(error)")
    }
    
    // 逆地理查询回调
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("response :\(response.formattedDescription())")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            mapView!.addAnnotation(annotation)
        }
    }

}
