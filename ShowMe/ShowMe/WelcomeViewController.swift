//
//  WelcomeViewController.swift
//  ShowMe
//
//  Created by lulu on 2016/11/10.
//  Copyright © 2016年 HandsomeHedgehog. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import SnapKit

class WelcomeViewController: UIViewController,UIScrollViewDelegate {
    
    var avaudioSession: AVAudioSession?
    
    var moviePlayer: MPMoviePlayerController!
    var timer: Timer!
    
    var btnRegiset: UIButton!
    var btnLogin: UIButton!
    var pageControl: UIPageControl!
    var showLabel: UILabel!
    var scrollView: UIScrollView!
    var imgKeep: UIImageView!
    
    let sportsArr:[String] = ["我运动我快乐","运动使人年轻","运动使人激情","运动挑战无极限"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createPlayer()
        initViews()
        setUpTimer()

    }
    
    func createPlayer(){
        avaudioSession = AVAudioSession.sharedInstance()
        
        do{
            try self.avaudioSession?.setCategory(AVAudioSessionCategoryAmbient)
        }catch{error}
        
        let urlStr = Bundle.main.path(forResource: "keep.mp4", ofType: nil)
        let url = NSURL(fileURLWithPath: urlStr!)
        moviePlayer = MPMoviePlayerController(contentURL: url as URL!)
        moviePlayer.play()
        moviePlayer.view.frame = self.view.bounds;
        self.view.addSubview(moviePlayer.view)
        moviePlayer.shouldAutoplay = true
        moviePlayer.controlStyle = .none
        moviePlayer.isFullscreen = true
        moviePlayer.repeatMode = .one
        NotificationCenter.default.addObserver(self, selector: #selector(playBackStateChange), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayer)
    }
    
    
    
    func initViews(){
        
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
    
        scrollView.contentSize = CGSize.init(width: self.view.bounds.width * 4, height: 60)
        scrollView.isUserInteractionEnabled = true
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        scrollView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.top.equalTo( self.view)
            make.bottom.equalTo(self.view.snp_bottom).offset(-100)
        }
        
        for i in 0..<sportsArr.count {
            showLabel = UILabel()
            showLabel.frame = CGRect.init(x: self.view.frame.width * CGFloat(i), y: self.view.bounds.height-150, width: self.view.bounds.width, height: 50)
        
            showLabel.text = sportsArr[i]
            showLabel.font = UIFont.systemFont(ofSize: 20)
            showLabel.textAlignment = .center
            showLabel.textColor = UIColor.white
            scrollView.addSubview(showLabel)
        }
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.green
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.isUserInteractionEnabled = true
        pageControl.addTarget(self, action: Selector(("pageChaned")), for: UIControlEvents.valueChanged)
//        pageControl.addTarget(self, action: #selector(pageChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(pageControl)
        pageControl.snp_makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(showLabel.snp_bottom).offset(5)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
        btnRegiset = UIButton()
        btnRegiset.layer.cornerRadius = 3
        btnRegiset.alpha = 0.4
        btnRegiset.backgroundColor = UIColor.black
        btnRegiset.setTitle("注册", for: .normal)
        btnRegiset.setTitleColor(UIColor.white, for: .normal)
        btnRegiset.setTitleColor(UIColor.black, for: .highlighted)
        btnRegiset.titleLabel?.textAlignment = .center
        btnRegiset.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(btnRegiset)
        btnRegiset.snp_makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo((self.view.bounds.width - 60)/2)
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
            make.left.equalTo(self.view.snp_left).offset(20)
        }
        
        btnLogin = UIButton()
        btnLogin.layer.cornerRadius = 3
        btnLogin.alpha = 0.4
        btnLogin.backgroundColor = UIColor.white
        btnLogin.setTitle("登录", for: .normal)
        btnLogin.setTitleColor(UIColor.black, for: .normal)
        btnLogin.setTitleColor(UIColor.white, for: .highlighted)
        btnLogin.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btnLogin.titleLabel?.textAlignment = .center
        self.view.addSubview(btnLogin)
        btnLogin.snp_makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo((self.view.bounds.width - 60)/2)
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
            make.right.equalTo(self.view.snp_right).offset(-20)
        }
        
        imgKeep = UIImageView()
        imgKeep.image = UIImage(named: "keep6")
        imgKeep.isUserInteractionEnabled = true
        self.view.addSubview(imgKeep)
        imgKeep.snp_makeConstraints { (make) in
            make.width.equalTo(167)
            make.height.equalTo(75)
            make.top.equalTo(self.view.snp_top).offset(230)
            make.centerX.equalTo(self.view.snp_centerX)
        }
    }
    
    
    func setUpTimer(){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerChanged), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
    }
    
    
    
    func  playBackStateChange() {}
    func  pageChanged(pageControl:UIPageControl) {
        
        let flag = CGFloat(pageControl.currentPage) * self.view.bounds.size.width
        self.scrollView.setContentOffset(CGPoint.init(x: flag, y: 0), animated: true)
    }
    
    func timerChanged(){
        let page = (self.pageControl.currentPage + 1)%4
        self.pageControl.currentPage = page
        self.pageChanged(pageControl: pageControl)
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer .invalidate()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(self.scrollView.contentOffset.x / self.view.bounds.width)
        self.pageControl.currentPage = page
        
        if page == -1{
            UIView.animate(withDuration: 0.3, animations: {
                self.pageControl.currentPage = 3
            })
        }else if page == 4{
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.pageControl.currentPage = 0
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            })
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.setUpTimer()
    }
    
    
//    func prefersStatusBarHidden() -> Bool {
//        return true
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
