//
//  RootViewController.swift
//  LCME
//
//  Created by zijia on 12/19/20.
//  Copyright © 2020 zijia. All rights reserved.
//

import UIKit

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController: RootViewController {
        return window?.rootViewController as! RootViewController
    }
}

class LCBaseTabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class MainViewController1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

class RootViewController: UIViewController {
    private var currentVC: UIViewController
    
    init() {
        self.currentVC = LCSplashViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addChild(currentVC)
        currentVC.view.frame = view.bounds
        view.addSubview(currentVC.view)
        currentVC.didMove(toParent: self)
    }
    
    func moveToLoginVC() {
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        addChild(loginVC)
        loginVC.view.frame = view.bounds
        view.addSubview(loginVC.view)
        loginVC.didMove(toParent: self)
        
        currentVC.willMove(toParent: nil)
        currentVC.view.removeFromSuperview()
        currentVC.removeFromParent()
        
        currentVC = loginVC
    }
    
    func moveToMainScreen() {
        let mainVC = MainViewController()
        mainVC.title = "title"
        let nav = UINavigationController(rootViewController: mainVC)
        
        let mainVC1 = MainViewController1()
        mainVC1.title = "title1"
        let nav1 = UINavigationController(rootViewController: mainVC1)
        
        let tabBar = LCBaseTabBar()
        tabBar.viewControllers = [nav, nav1]
        
        animateDismissTransition(to: tabBar)
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        currentVC.willMove(toParent: nil)
        addChild(new)
        new.view.frame = initialFrame
        transition(from: currentVC, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { (_) in
            self.currentVC.removeFromParent()
            new.didMove(toParent: self)
            self.currentVC = new
            completion?()
        }
    }
}

class LCSplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AppDelegate.shared.rootViewController.moveToMainScreen()
        }
    }
}
