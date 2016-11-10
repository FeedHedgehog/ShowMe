//
//  NearByViewController.swift
//  ShowMe
//
//  Created by lulu on 2016/11/10.
//  Copyright © 2016年 HandsomeHedgehog. All rights reserved.
//

import UIKit

class NearByViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate {

    
    var mapView:MAMapView!
    var search: AMapSearchAPI!
    var pointAnnotation:MAPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewSetup()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.isShowTraffic=true
        mapView.isShowsUserLocation=true
        mapView.userTrackingMode=MAUserTrackingMode.follow
        mapView.showsCompass=false
        mapView.pausesLocationUpdatesAutomatically=false
        mapView.allowsBackgroundLocationUpdates=true
        
        pointAnnotation = MAPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude)
        pointAnnotation.title = "xx项目"
        pointAnnotation.subtitle = "此项目知道啦好打理好爱上的离婚"
        
        mapView.addAnnotation(pointAnnotation)
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
        mapView!.delegate = self
        
        
        //        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 40.078537, longitude: 116.5871)
        //        let macircle = MACircle.init(center: coordinate, radius: 200.0)
        //        mapView!.addAnnotation(macircle)
        
        self.view.addSubview(mapView!)
        
        let compassX = mapView?.compassOrigin.x
        
        let scaleX = mapView?.scaleOrigin.x
        
        //设置指南针和比例尺的位置
        mapView?.compassOrigin = CGPoint(x: compassX!, y: 21)
        
        mapView?.scaleOrigin = CGPoint(x: scaleX!, y: 21)
        mapView!.distanceFilter = 10.0
        mapView!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        mapView!.setZoomLevel(17.5, animated: true)
        mapView.setCenter(mapView.centerCoordinate, animated: true)
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
    
//        func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//            if annotation.isKind(of: MAAnnotationView())
//            {
//                let pointReuseIndentifier = "pointReuseIndentifier"
//                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndentifier) as! MAPinAnnotationView
//                if(annotationView == nil){
//                    annotationView = MAPinAnnotationView.init(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
//                }
//                annotationView.canShowCallout=true
//                annotationView.animatesDrop=true
//                annotationView.isDraggable=true
//                annotationView.pinColor=MAPinAnnotationColor.purple
//                return annotationView
//            }
//    
//    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!) {
        print("latitude :\(userLocation.coordinate.latitude), longtitude: \(userLocation.coordinate.longitude)")
        
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
