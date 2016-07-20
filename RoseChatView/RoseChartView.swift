//
//  RoseChartView.swift
//  RoseChatView
//
//  Created by wuqiuhao on 2016/7/19.
//  Copyright © 2016年 Hale. All rights reserved.
//

import UIKit
import AudioToolbox

class Petal {
    var title: String!
    var percent: CGFloat!
    var layer: CAShapeLayer?
    var selected: Bool!
    var radius: CGFloat?
    var color: UIColor!
    var startAngle: CGFloat?
    var endAngle: CGFloat?
    
    init(title: String, percent: CGFloat , selected: Bool, color: UIColor) {
        self.title = title
        self.percent = percent
        self.selected = selected
        self.color = color
    }
}

class BtnView: UIView {
    
    var lbtitle: UILabel!
    var btnPetal: UIButton!
    
    init(frame: CGRect, color: UIColor, title: String) {
        super.init(frame: frame)
        lbtitle = UILabel(frame: CGRect(x: self.bounds.height - 5, y: 0, width: self.bounds.width - self.bounds.height + 5, height: self.bounds.height))
        lbtitle.text = title
        lbtitle.textColor = UIColor.whiteColor()
        lbtitle.font = UIFont.systemFontOfSize(10)
        btnPetal = UIButton(type: .Custom)
        btnPetal.frame = CGRect(x: 0, y: 5, width: self.bounds.height - 10, height: self.bounds.height - 10)
        btnPetal.layer.cornerRadius = 5
        btnPetal.backgroundColor = color
        self.addSubview(btnPetal)
        self.addSubview(lbtitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RoseChartView: UIView {
    
    var petals: [Petal]!
    var contentView: UIView!
    var chartView: UIView!
    var titleView: UIView!
    var firstLoad = true
    var textLayer: CATextLayer!
    var percentLayer: CATextLayer!
    var currentIndex = 0
    var centerTitle: String! {
        didSet {
            textLayer.string = centerTitle
        }
    }
    
    var centerPercent: String! {
        didSet {
            percentLayer.string = centerPercent
            percentLayer.foregroundColor = petals[currentIndex].color.CGColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDatas()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDatas()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if firstLoad {
            firstLoad = false
            configUI()
        }
    }
    
    func initDatas() {
        petals = [Petal(title: "Rose1", percent: 0.35,  selected: true, color: UIColor(red: 251 / 255.0, green: 73 / 255.0, blue: 124 / 255.0, alpha: 1)),
                  Petal(title: "Rose2", percent: 0.30, selected: false, color: UIColor(red: 255 / 255.0, green: 199 / 255.0, blue: 96 / 255.0, alpha: 1)),
                  Petal(title: "Rose3", percent: 0.15, selected: false, color: UIColor(red: 111 / 255.0, green: 230 / 255.0, blue: 3 / 255.0, alpha: 1)),
                  Petal(title: "Rose4", percent: 0.20, selected: false, color: UIColor(red: 77 / 255.0, green: 202 / 255.0, blue: 254 / 255.0, alpha: 1))]
    }
    
    func configUI() {
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        chartView = UIView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.height, height: contentView.bounds.height))
        titleView = UIView(frame: CGRect(x: 0, y: self.bounds.height - 30, width: self.bounds.width, height: 30))
        self.addSubview(contentView)
        self.addSubview(titleView)
        contentView.addSubview(chartView)
        
        let center = chartView.center
        let centerLayer = CAShapeLayer()
        let centerRadius = chartView.frame.width / 10
        let path = UIBezierPath(arcCenter: center, radius: centerRadius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        centerLayer.path = path.CGPath
        centerLayer.lineWidth = centerRadius / 5
        centerLayer.strokeColor = UIColor(white: 0.2, alpha: 1).CGColor
        centerLayer.fillColor = UIColor.whiteColor().CGColor
        centerLayer.zPosition = 5
        textLayer = CATextLayer()
        textLayer.fontSize = 10
        centerTitle = petals[0].title
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.frame.size = CGSize(width: centerRadius * 2 - 15, height: 15)
        textLayer.position = CGPoint(x: center.x, y: center.y + 10)
        textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.foregroundColor = UIColor.grayColor().CGColor
        centerLayer.addSublayer(textLayer)
        percentLayer = CATextLayer()
        percentLayer.fontSize = 14
        centerPercent = "\(Int(petals[0].percent! * 100))%"
        percentLayer.alignmentMode = kCAAlignmentCenter
        percentLayer.frame.size = CGSize(width: centerRadius * 2 - 15, height: 15)
        percentLayer.position = CGPoint(x: center.x, y: center.y - 8)
        percentLayer.contentsScale = UIScreen.mainScreen().scale
        percentLayer.foregroundColor = petals[0].color.CGColor
        centerLayer.addSublayer(percentLayer)
        chartView.layer.addSublayer(centerLayer)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(chartViewTaped(_:)))
        chartView.userInteractionEnabled = true
        chartView.addGestureRecognizer(gesture)
        
        
        var startAngle = CGFloat(M_PI_2)
        for i in 0..<petals.count {
            let shapeLayer = CAShapeLayer()
            let endAngle = startAngle + CGFloat(M_PI * 2) * petals[i].percent!
            petals[i].radius = (contentView.bounds.width / 2 - 80) - 10 * CGFloat(i)
            let path = UIBezierPath()
            path.moveToPoint(center)
            shapeLayer.zPosition = 3 - CGFloat(i)
            if i == 0 {
                shapeLayer.zPosition = 4
                path.addArcWithCenter(center, radius: petals[i].radius! + 20, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            } else {
                path.addArcWithCenter(center, radius: petals[i].radius!, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            }
            shapeLayer.path = path.CGPath
            shapeLayer.fillColor = petals[i].color.CGColor
            shapeLayer.shadowOpacity = 0.5
            shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
            shapeLayer.shadowRadius = 5
            chartView.layer.addSublayer(shapeLayer)
            petals[i].startAngle = startAngle
            petals[i].endAngle = endAngle
            petals[i].layer = shapeLayer
            startAngle = endAngle
            
            let btnView = BtnView(frame: CGRect(x: contentView.frame.origin.x + contentView.frame.width - 60 * (CGFloat(i)+1), y: 0, width: 60, height: 30), color: petals[i].color, title: petals[i].title!)
            btnView.btnPetal.tag = i * 10
            btnView.btnPetal.addTarget(self, action: #selector(chartViewTaped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            titleView.addSubview(btnView)
            
        }
    }
    
    
    func chartViewTaped(sender: AnyObject) {
        if sender is UIGestureRecognizer {
            let gesture = sender as! UIGestureRecognizer
            for i in 0..<petals.count {
                let path = UIBezierPath(CGPath: petals[i].layer!.path!)
                if path.containsPoint(gesture.locationInView(gesture.view)) {
                    guard petals[i].selected == nil || petals[i].selected! == false  else {
                        return
                    }
                    currentIndex = i
                    updateUI(petals[currentIndex])
                }
            }
        } else if sender is UIButton {
            let btn = sender as! UIButton
            currentIndex = btn.tag / 10
            updateUI(petals[currentIndex])
        }
    }
    
    func updateUI(petal: Petal) {
        centerTitle = petal.title
        centerPercent = "\(Int(petal.percent! * 100))%"
        AudioServicesPlaySystemSound((UIApplication.sharedApplication().delegate as! AppDelegate).soundID)
        let _ = petals.map(){ $0.selected = false }
        let center = chartView.center
        petal.selected = true
        for k in 0..<petals.count {
            if petals[k].layer!.zPosition == 4 {
                let animation1 = CASpringAnimation(keyPath: "zPosition")
                animation1.toValue = 3 - CGFloat(k)
                let animation2 = CASpringAnimation(keyPath: "path")
                let path = UIBezierPath()
                path.moveToPoint(center)
                path.addArcWithCenter(center, radius: petals[k].radius!, startAngle: petals[k].startAngle!, endAngle: petals[k].endAngle!, clockwise: true)
                petals[k].layer?.path = path.CGPath
                animation2.damping = 35
                animation2.stiffness = 10000
                animation2.mass =  1.5
                let groupAnimation = CAAnimationGroup()
                groupAnimation.animations = [animation1,animation2]
                groupAnimation.fillMode = kCAFillModeForwards
                groupAnimation.duration = 0.5
                groupAnimation.removedOnCompletion = false
                groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                petals[k].layer?.addAnimation(groupAnimation, forKey: "transitionBack")
                petals[k].layer?.zPosition = 3 - CGFloat(k)
            }
        }
        
        let animation1 = CASpringAnimation(keyPath: "zPosition")
        animation1.toValue = 4
        let animation2 = CASpringAnimation(keyPath: "path")
        let path = UIBezierPath()
        path.moveToPoint(center)
        path.addArcWithCenter(center, radius: petal.radius! + 20, startAngle: petal.startAngle!, endAngle: petal.endAngle!, clockwise: true)
        animation2.toValue = path.CGPath
        
        animation2.damping = 35
        animation2.stiffness = 10000
        animation2.mass = 1.5
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation1,animation2]
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.duration = 0.5
        groupAnimation.removedOnCompletion = false
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        petal.layer?.addAnimation(groupAnimation, forKey: "transition")
        petal.layer?.zPosition = 4
    }
}
