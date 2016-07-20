//
//  ViewController.swift
//  RoseChatView
//
//  Created by wuqiuhao on 2016/7/19.
//  Copyright © 2016年 Hale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgColor = UIColor(red: 16 / 255.0, green: 32 / 255.0, blue: 65 / 255.0, alpha: 1).CGColor as AnyObject
        let bgColor2 = UIColor(red: 73 / 255.0, green: 117 / 255.0, blue: 152 / 255.0, alpha: 1).CGColor as AnyObject
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.colors = [bgColor,bgColor2]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

