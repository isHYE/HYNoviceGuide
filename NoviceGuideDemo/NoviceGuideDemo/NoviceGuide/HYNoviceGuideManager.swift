//
//  HYNoviceGuideManager.swift
//  PTHLearning
//
//  Created by 黄益 on 2021/1/4.
//

import Foundation
import UIKit

/// 屏幕宽度
let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
/// 屏幕高度
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

class HYNoviceGuideManager: UIView {
    
    /// 新手引导类型
    enum GuideType {
        /// 圆形引导
        case circular(_ config: CircularGuideConfigModel)
        /// 矩形引导
        case rectangle(_ config: RectangleGuideConfigModel)
    }
    
    /// 新手引导结束回调
    var fininshBlock: (() -> Void)?
    /// 新手引导配置
    private var guideType: [GuideType] = []
    /// 当前新手引导序号
    private var currentGuideIndex: Int = 0
    
    private let contentEdge: CGFloat = 10
    
    /// 背景蒙版
    private lazy var noviceGuideDarkView = { () -> UIView in
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.tag = 67876
        view.isUserInteractionEnabled = true
        view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(confirmCurrentGuide))
        view.addGestureRecognizer(tap)
        return view
    }()

    convenience init(_ guideType: [GuideType])
    {
        
        self.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        UIApplication.shared.windows.first?.addSubview(self)
        self.guideType = guideType
    }
    
    /** 开始新手引导*/
    func startGuide() {
        continueNoviceGuide()
    }
    
    /** 结束新手引导*/
    func finishNoviceGuide() {
        UIView.animate(withDuration: 0.2, animations: {
            for subView in self.subviews {
                subView.alpha = 0
            }
        }, completion: {
            (_) in
            for subView in self.subviews {
                subView.removeFromSuperview()
            }
            
            if let block = self.fininshBlock {
                block()
            }
            
            self.removeFromSuperview()
        })
    }
    
    /** 确认当前引导*/
    @objc private func confirmCurrentGuide() {
        continueNoviceGuide(noviceGuideIndex: currentGuideIndex + 1)
    }
    
    /** 进行下一步新手引导*/
    private func continueNoviceGuide(noviceGuideIndex: Int = 0) {
        currentGuideIndex = noviceGuideIndex
        if noviceGuideIndex == 0 {
            addSubview(noviceGuideDarkView)
        }
        
        // 移除镂空蒙版
        for sublayer in noviceGuideDarkView.layer.sublayers ?? []{
            sublayer.removeFromSuperlayer()
        }
        
        // 移除说明视图
        for subView in subviews {
            if subView.tag != 67876 {
                subView.removeFromSuperview()
            }
        }
        
        if guideType.count > noviceGuideIndex {
            let noviceGuideType = guideType[noviceGuideIndex]
            
            // 引导贝塞尔
            var bezierPath: UIBezierPath?
            // 基础配置
            var baseConfig: BaseGuideConfigModel?
            // 镂空位置
            var hollowFrame: CGRect?
            
            switch noviceGuideType {
            
            case .circular(let config):
                baseConfig = config
                // 引导镂空位置
                var guideFrame: CGRect?
                if let hollowView = config.hollowView {
                    guideFrame = hollowView.convert(hollowView.bounds, to: nil)
                } else if let hollowFrame = config.hollowFrame {
                    guideFrame = hollowFrame
                }
                
                if let guideFrame = guideFrame {
                    // 圆形引导直径
                    let circleDiameter = config.diameter ?? max(guideFrame.size.width, guideFrame.size.height)
                    // 圆形引导
                    let circleGuideFrame = CGRect(x: guideFrame.origin.x, y: guideFrame.origin.y, width: circleDiameter, height: circleDiameter)
                    
                    hollowFrame = circleGuideFrame
                    // 引导贝塞尔
                    bezierPath = UIBezierPath(roundedRect: circleGuideFrame, cornerRadius: circleDiameter / 2)
                }
                
                break
                
            case .rectangle(let config):
                baseConfig = config
                // 引导镂空位置
                var guideFrame: CGRect?
                if let hollowView = config.hollowView {
                    guideFrame = hollowView.convert(hollowView.bounds, to: nil)
                } else if let hollowFrame = config.hollowFrame {
                    guideFrame = hollowFrame
                }
                
                if let guideFrame = guideFrame {
                    
                    hollowFrame = guideFrame
                    // 引导贝塞尔
                    bezierPath = UIBezierPath(roundedRect: guideFrame,
                                              byRoundingCorners: config.corners,
                                              cornerRadii: CGSize(width: config.cornerRadius, height: config.cornerRadius))
                }
                
                break
            }
            
            guard let config = baseConfig, let guideFrame = hollowFrame, let guideBezier = bezierPath else {
                // 无法获取引导贝塞尔图 -> 进行下一引导或退出引导
                if guideType.count > noviceGuideIndex {
                    // 进行下一引导
                    continueNoviceGuide(noviceGuideIndex: noviceGuideIndex + 1)
                } else {
                    // 结束引导
                    finishNoviceGuide()
                }
                return
            }
            
            
            let maskPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            
            let path = guideBezier.reversing()
            maskPath.append(path)
            
            let maskLayer = CAShapeLayer()
            
            maskLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            maskLayer.path = maskPath.cgPath;
            
            noviceGuideDarkView.layer.addSublayer(maskLayer)
            noviceGuideDarkView.layer.mask = maskLayer
            
            // 上一尺寸
            var preFrame = guideFrame
            for guideExplain in config.guideArray ?? [] {
                guard let explainView = guideExplain.view else {
                    return
                }
                
                var currentFrame: CGRect
                addSubview(explainView)
                /// 方位
                switch guideExplain.location {
                case .top(let offset):
                    currentFrame = CGRect(x: preFrame.origin.x + preFrame.size.width / 2 - guideExplain.size.width / 2 + (offset?.horizontal ?? 0),
                                          y: preFrame.origin.y - contentEdge - guideExplain.size.height + (offset?.vertical ?? 0),
                                          width: guideExplain.size.width,
                                          height: guideExplain.size.height)
                    break
                    
                case .bottom(let offset):
                    currentFrame = CGRect(x: preFrame.origin.x + preFrame.size.width / 2 - guideExplain.size.width / 2 + (offset?.horizontal ?? 0),
                                          y: preFrame.origin.y + contentEdge + preFrame.size.height + (offset?.vertical ?? 0),
                                          width: guideExplain.size.width,
                                          height: guideExplain.size.height)
                    break
                    
                case .left(let offset):
                    currentFrame = CGRect(x: preFrame.origin.x - contentEdge - guideExplain.size.width + (offset?.horizontal ?? 0),
                                          y: preFrame.origin.y + preFrame.size.height / 2 - guideExplain.size.height / 2 + (offset?.vertical ?? 0),
                                          width: guideExplain.size.width,
                                          height: guideExplain.size.height)
                    break
                    
                case .right(let offset):
                    currentFrame = CGRect(x: preFrame.origin.x + contentEdge + preFrame.size.width + (offset?.horizontal ?? 0),
                                          y: preFrame.origin.y + preFrame.size.height / 2 - guideExplain.size.height / 2 + (offset?.vertical ?? 0),
                                          width: guideExplain.size.width,
                                          height: guideExplain.size.height)
                    break
                    
                }
                // 越界矫正
                var newY = currentFrame.origin.y <= 0 ? 0 : currentFrame.origin.y
                if (newY + currentFrame.size.height) >= SCREEN_HEIGHT {
                    newY = SCREEN_HEIGHT - currentFrame.size.height
                }
                
                var newX = currentFrame.origin.x <= 0 ? 0 : currentFrame.origin.x
                if (newX + currentFrame.size.width) >= SCREEN_WIDTH {
                    newX = SCREEN_WIDTH - currentFrame.size.width
                }
                
                currentFrame = CGRect(x: newX, y: newY, width: currentFrame.size.width, height: currentFrame.size.height)
                
                explainView.frame = currentFrame
                preFrame = currentFrame
            }
            
        } else {
            finishNoviceGuide()
        }
    }
}
