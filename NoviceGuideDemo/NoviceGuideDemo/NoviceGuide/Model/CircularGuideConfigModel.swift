//
//  CircularGuideConfigModel.swift
//  NoviceGuideDemo
//
//  Created by 黄益 on 2021/1/4.
//

import Foundation
import UIKit

class CircularGuideConfigModel: BaseGuideConfigModel {
    
    /// 圆形镂空直径（不传值则取 hollowView｜hollowFrame 宽高较大值）
    var diameter: CGFloat?
    
    convenience init(diameter: CGFloat? = nil, hollowView: UIView? = nil, hollowFrame: CGRect? = nil, guideArray: [GuideConfig]? = nil) {
        self.init(hollowView: hollowView, hollowFrame: hollowFrame, guideArray: guideArray)
        
        self.diameter = diameter
    }
}
