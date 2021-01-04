//
//  BaseGuideConfigModel.swift
//  NoviceGuideDemo
//
//  Created by 黄益 on 2021/1/4.
//

import Foundation
import UIKit

class BaseGuideConfigModel {
    
    /// 提示相对位置
    enum RemindLocation {
        /// 上方
        case top(_ offset: UIOffset? = nil)
        /// 下方
        case bottom(_ offset: UIOffset? = nil)
        /// 左方
        case left(_ offset: UIOffset? = nil)
        /// 右方
        case right(_ offset: UIOffset? = nil)
    }
    
    /// 引导配置
    typealias GuideConfig = (view: UIView?, size: CGSize, location: RemindLocation)
    
    
    /// 指引镂空视图（与hollowFrame传其一，优先使用hollowView），用于定位镂空位置
    var hollowView: UIView?
    /// 指引镂空位置（与hollowView传其一，优先使用hollowView），用于定位镂空位置
    var hollowFrame: CGRect?
    
    
    /// 引导集合
    var guideArray: [GuideConfig]?
    
    convenience init(hollowView: UIView? = nil, hollowFrame: CGRect? = nil, guideArray: [GuideConfig]? = nil) {
        self.init()
        
        self.hollowView = hollowView
        self.hollowFrame = hollowFrame
        self.guideArray = guideArray
    }
}
