//
//  PairAnimationView.swift
//  zhiai
//
//  Created by Mountain on 2021/11/26.
//  Copyright © 2021 ai. All rights reserved.
//
import Foundation
import UIKit
import Masonry

class PairAnimationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ai_setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAllAnimation()  {
        setupAnimateLayout()
        shapeLayer.add(animationGroup, forKey: "animationGroup")
        heartImgView.layer.add(setUpAnimation(), forKey: "scale")
        rotaImgView.layer.add(rotationAnimation(), forKey: "rotationAnimation")
        updateLoadingLabel()
        serachingLabel.text = "匹配中..."
        bgView.isHidden = false
        rotaImgView.isHidden = false
        heartImgView.isHidden = false
        
        bgFailView.isHidden = true
        backBtn.isHidden = true
        tryBtn.isHidden = true
        tispLabel.isHidden = true
        speedBtn.isHidden = true
    }
    
    func removeAllAnimation(_ msg: String?, _ isSpeedUp: Bool)  {
        setResultLayout()
        shapeLayer.removeAllAnimations()
        heartImgView.layer.removeAnimation(forKey: "scale")
        rotaImgView.layer.removeAnimation(forKey: "rotationAnimation")
        serachingLabel.text = ""
        bgView.isHidden = true
        rotaImgView.isHidden = true
        heartImgView.isHidden = true
        
        bgFailView.isHidden = false
        speedBtn.isHidden = isSpeedUp
        backBtn.isHidden = !isSpeedUp
        tryBtn.isHidden = false
        tispLabel.isHidden = false
        guard let msg = msg else { return }
        tispLabel.text = msg
    }
    
   
    
    func ai_setupViews() {
        addSubview(bgView)
        bgView.layer.addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(shapeLayer)
        addSubview(rotaImgView)
        addSubview(heartImgView)
        addSubview(serachingLabel)
        
        addSubview(bgFailView)
        addSubview(backBtn)
        addSubview(speedBtn)
        addSubview(tryBtn)
        addSubview(tispLabel)
        startAllAnimation()
    }
    
    func setupAnimateLayout() {
        bgView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
        
        rotaImgView.mas_makeConstraints { make in
            make?.width.height()?.mas_equalTo()(120)
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(UIScreen.main.bounds.height/3)
        }
        
        heartImgView.mas_makeConstraints { make in
            make?.width.height()?.equalTo()(60)
            make?.centerX.equalTo()(rotaImgView)
            make?.centerY.equalTo()(rotaImgView)
        }
        
        serachingLabel.mas_makeConstraints { make in
            make?.left.equalTo()(UIScreen.main.bounds.width/2 - 30)
            make?.bottom.equalTo()(-UIScreen.main.bounds.height/3)
        }
    }
    
    func setResultLayout() {
        bgFailView.mas_makeConstraints { make in
            make?.width.equalTo()(118)
            make?.height.equalTo()(96)
            make?.centerX.equalTo()(self)
            make?.centerY.equalTo()(self)
        }
        
        tispLabel.mas_makeConstraints { make in
            make?.top.equalTo()(bgFailView.mas_bottom)?.offset()(32)
            make?.left.equalTo()(50)
            make?.right.equalTo()(-50)
        }
        
        backBtn.mas_makeConstraints { make in
            make?.width.equalTo()(255)
            make?.height.equalTo()(45)
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(tispLabel.mas_bottom)?.offset()(160)
        }
        
        speedBtn.mas_makeConstraints { make in
            make?.width.equalTo()(255)
            make?.height.equalTo()(45)
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(tispLabel.mas_bottom)?.offset()(160)
        }
        
        tryBtn.mas_makeConstraints { make in
            make?.width.equalTo()(255)
            make?.height.equalTo()(45)
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(backBtn.mas_bottom)?.offset()(22)
        }
    }
    
    
    lazy var bgView: UIImageView = {
        let new = UIImageView()
        new.image = UIImage(named: "heart_bg")
        return new
    }()
    
    lazy var heartImgView: UIImageView = {
        let new = UIImageView()
        new.image = UIImage(named: "heart")
        return new
    }()
    
    lazy var rotaImgView: UIImageView = {
        let new = UIImageView()
        new.image = UIImage(named: "online_black_circle")
        return new
    }()
    
    let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: (UIScreen.main.bounds.width - 300)/2, y: (UIScreen.main.bounds.height/3 + 60 - 150), width: 300, height: 300)

        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 300, height: 300)).cgPath
        shapeLayer.fillColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 0.3).cgColor
        shapeLayer.opacity = 0.0
        return shapeLayer
    }()
    
    lazy var replicatorLayer: CAReplicatorLayer = {
        let replicatorLayer = CAReplicatorLayer()
//        replicatorLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        replicatorLayer.instanceDelay = 0.2  //复制副本的时间延迟
        replicatorLayer.instanceCount = 3
        replicatorLayer.addSublayer(shapeLayer)
        return replicatorLayer
    }()
    
    lazy var animationGroup: CAAnimationGroup = {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [alphaAnimation(), scaleAnimation()]
        animationGroup.duration = 1.5
        animationGroup.autoreverses = false
        animationGroup.repeatCount = MAXFLOAT
        animationGroup.isRemovedOnCompletion = false
        return animationGroup
    }()
    
    //波浪放大动画
    func scaleAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.xy")
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: 1)
        animation.duration = 0.8
        return animation
    }
    
    //波浪透明度动画
    func alphaAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.values = [0.6,0.4,0]
        animation.keyTimes = [0,0.4,1]    //第一个时间值必须为0，列表中的最后一个时间值必须为1
        return animation
    }
    
    //心跳动画
    func setUpAnimation() -> CABasicAnimation{
        let scalAnima = CABasicAnimation(keyPath: "transform.scale.xy")
        scalAnima.fromValue = NSNumber(value:1)
        scalAnima.toValue = NSNumber(value:1.6)
        scalAnima.duration = 0.6
        scalAnima.autoreverses = true
        scalAnima.repeatCount = MAXFLOAT
        scalAnima.isRemovedOnCompletion = false
        return scalAnima
    }
    
    //扇形旋转动画
    func rotationAnimation() -> CABasicAnimation{
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.isRemovedOnCompletion = false
        return rotationAnimation
    }
    
    lazy var serachingLabel: UILabel = {
        let new = UILabel()
//        new.text = "搜索中..."
        new.font = .boldSystemFont(ofSize: 18)
        new.textColor = .white
        new.textAlignment = .left
        return new
    }()
    
    
    @objc func updateLoadingLabel() {
//       if loading {
           if serachingLabel.text == "匹配中..." {
               serachingLabel.text = "匹配中"
           } else if serachingLabel.text == "匹配中"{
               serachingLabel.text = "匹配中."
           }else if serachingLabel.text == "匹配中."{
               serachingLabel.text = "匹配中.."
           }else {
               serachingLabel.text = "匹配中..."
           }
        perform(#selector(updateLoadingLabel), with: nil, afterDelay: 0.5) //each second
//       }

   }
    
    
    
    //MARK: -
    
    lazy var bgFailView: UIImageView = {
        let new = UIImageView()
        new.image = UIImage(named: "pair_faile_bg")
        return new
    }()
    
    lazy var tispLabel: UILabel = {
        let new = UILabel()
        new.font = .systemFont(ofSize: 16)
        new.textColor = UIColor.gray
        new.textAlignment = .center
        new.numberOfLines = 0
        return new
    }()
    
    lazy var backBtn:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 22.5
        btn.layer.masksToBounds = true
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.cyan
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return btn
    }()
    
    //加速按钮
    lazy var speedBtn:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 22.5
        btn.layer.masksToBounds = true
        btn.setTitle("提升排序，加速配对", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
//        btn.setBackgroundImage(UIImage(gradientColors: [UIColor("#F2186E"),UIColor("#882FFB")]), for: .normal)
        return btn
    }()
    
    lazy var tryBtn:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 22.5
        btn.layer.masksToBounds = true
        btn.setTitle("继续尝试", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return btn
    }()
    


}
