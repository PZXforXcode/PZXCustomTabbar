//
//  PZXTabBar.swift
//  PZXCustomTabbar
//
//  Created by 彭祖鑫 on 2025/7/4.
//

import UIKit

class PZXTabBar: UITabBar {
    
    // MARK: - 属性
    // 持有我们的自定义 UIView
    let customTabBarView: PZXCustomTabBar
    
    // 私有属性，方便访问中心按钮
    private var centerView: UIView? {
        return customTabBarView.centerView
    }
    
    // MARK: - 初始化
    init(customTabBarView: PZXCustomTabBar) {
        self.customTabBarView = customTabBarView
        super.init(frame: .zero)
        
        // 将自定义视图添加为子视图
        addSubview(customTabBarView)
        
        // 使系统原生的TabBar背景透明，以完全显示我们的自定义视图
        self.backgroundImage = UIImage()
        self.shadowImage = UIImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        // 确保我们的自定义视图始终填满整个TabBar的区域
        customTabBarView.frame = self.bounds
        
        // 将自定义视图置于顶层，确保它能响应事件
        self.bringSubviewToFront(customTabBarView)
    }
    
    // MARK: - 点击事件处理
    /// 重写hitTest方法，处理超出TabBar区域的中心按钮的点击事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 如果视图隐藏、透明或不可交互，则不处理
        if self.isHidden || self.alpha == 0 || !self.isUserInteractionEnabled {
            return super.hitTest(point, with: event)
        }
        
        guard let centerView = self.centerView else {
            return super.hitTest(point, with: event)
        }
        
        // 将点击坐标从TabBar的坐标系转换到中心按钮的坐标系
        let centerViewPoint = self.convert(point, to: centerView)
        
        // 如果转换后的坐标在中心按钮的范围内，则认为点击了中心按钮
        if centerView.bounds.contains(centerViewPoint) {
            return centerView
        }
        
        // 否则，执行系统默认的点击判断
        return super.hitTest(point, with: event)
    }
} 