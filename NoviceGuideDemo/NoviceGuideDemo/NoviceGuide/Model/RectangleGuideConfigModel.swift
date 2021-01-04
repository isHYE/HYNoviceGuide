//
//  RectangleGuideConfigModel.swift
//  NoviceGuideDemo
//
//  Created by 黄益 on 2021/1/4.
//

import Foundation
import UIKit

class RectangleGuideConfigModel: BaseGuideConfigModel {
    
    /// 圆角度数
    var cornerRadius: CGFloat = 0
    /// 圆角位置
    var corners: UIRectCorner = .allCorners
    
    convenience init(cornerRadius: CGFloat = 0, corners: UIRectCorner = .allCorners, hollowView: UIView? = nil, hollowFrame: CGRect? = nil, guideArray: [GuideConfig]? = nil) {
        self.init(hollowView: hollowView, hollowFrame: hollowFrame, guideArray: guideArray)
        
        self.cornerRadius = cornerRadius
        self.corners = corners
    }
    
}
