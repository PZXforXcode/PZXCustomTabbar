//
//  ViewController.swift
//  PZXCustomTabbar
//
//  Created by 彭祖鑫 on 2025/7/4.
//
// 后续需要解决 hidesBottomBarWhenPushed 方案，pzx_customTabBar 是在 PZXTabbarViewController 层级的 参考微信

import UIKit

/// 自定义 TabBar 控制器，继承自 UITabBarController 以获得系统级功能
class PZXTabbarViewController: UITabBarController {
    
    // MARK: - 私有属性
    private let titles: [String]
    private let unselectedIcons: [String]
    private let selectedIcons: [String]
    private let selectedColor: UIColor
    private let unselectedColor: UIColor
    private var centerView: UIView?
    // 动画开关参数
    private let enableTapAnimation: Bool
    
    // 我们自定义的 TabBar 视图 (UIView)
    private var pzx_customTabBar: PZXCustomTabBar!
    
    // MARK: - 初始化
    /// - Parameters:
    ///   - viewControllers: 需要展示的子控制器，会直接赋值给 UITabBarController
    ///   - titles: 按钮标题
    ///   - unselectedIcons: 未选中图标
    ///   - selectedIcons:   选中图标
    ///   - selectedColor: 选中状态下的颜色
    ///   - unselectedColor: 未选中状态下的颜色
    ///   - centerView: 可选中心按钮视图
    ///   - enableTapAnimation: 是否开启点击动画效果，默认为true
    init(viewControllers: [UIViewController], titles: [String], unselectedIcons: [String], selectedIcons: [String], selectedColor: UIColor, unselectedColor: UIColor, centerView: UIView? = nil, enableTapAnimation: Bool = true) {
        self.titles = titles
        self.unselectedIcons = unselectedIcons
        self.selectedIcons = selectedIcons
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.centerView = centerView
        self.enableTapAnimation = enableTapAnimation
        super.init(nibName: nil, bundle: nil)
        
        // 直接将子控制器设置给父类
        self.viewControllers = viewControllers
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 确保自定义TabBar的布局正确
        updateCustomTabBarFrame()
    }
    
    // MARK: - 构建自定义 TabBar
    private func setupCustomTabBar() {
        // 1. 完全隐藏系统TabBar，避免手势冲突
        self.tabBar.isHidden = true
        
        // 2. 初始化我们自定义的 UIView，传入动画开关参数
        pzx_customTabBar = PZXCustomTabBar(
            titles: titles,
            unselectedIcons: unselectedIcons,
            selectedIcons: selectedIcons,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            centerView: centerView,
            enableTapAnimation: enableTapAnimation
        )
        
        // 3. 将自定义TabBar直接添加到主视图上
        view.addSubview(pzx_customTabBar)
        pzx_customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 4. 设置约束，确保TabBar贴到底部并适配安全区域
        NSLayoutConstraint.activate([
            pzx_customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pzx_customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pzx_customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor), // 直接贴到底部
            pzx_customTabBar.heightAnchor.constraint(equalToConstant: 83) // 标准TabBar高度 + 安全区域
        ])
        
        // 5. 设置回调：当自定义视图中的按钮被点击时，切换 UITabBarController 的 selectedIndex
        pzx_customTabBar.onItemSelected = { [weak self] index in
            self?.selectedIndex = index
        }
        
        // 6. 中心按钮点击回调
        pzx_customTabBar.onCenterTapped = {
            print("中心按钮点击")
        }
        
        // 7. 默认选中第一个
        selectTab(at: 0)
    }
    
    /// 更新自定义TabBar的frame，确保布局正确
    private func updateCustomTabBarFrame() {
        // 确保自定义TabBar始终在正确的层级
        view.bringSubviewToFront(pzx_customTabBar)
    }
    
    // MARK: - 对外开放功能
    /// 主动选择某个Tab
    func selectTab(at index: Int) {
        self.selectedIndex = index
        pzx_customTabBar.selectItem(at: index)
    }
    
    /// 设置某个Tab的红点显隐
    func setBadge(at index: Int, visible: Bool) {
        pzx_customTabBar.setBadge(at: index, visible: visible)
    }
    
    /// 动态开关点击动画
    func setTapAnimationEnabled(_ enabled: Bool) {
        pzx_customTabBar.setTapAnimationEnabled(enabled)
    }
}

// MARK: - UIApplication 快捷获取根 TabbarVC
extension UIApplication {
    /// 全局快捷访问自定义 TabBar 控制器
    static var pzxTabbarVC: PZXTabbarViewController? {
        // 由于我们的根控制器现在就是 PZXTabbarViewController，所以可以直接转换
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first?
            .rootViewController as? PZXTabbarViewController
    }
}


// MARK: - UIViewController Extension for Custom TabBar
// 这一部分不再需要，可以直接使用系统提供的 hidesBottomBarWhenPushed 属性
/*
 extension UIViewController {
     /// 类似系统的 hidesBottomBarWhenPushed，用于自定义TabBar
     var pzxHidesBottomBarWhenPushed: Bool {
         get {
             return objc_getAssociatedObject(self, AssociatedKeys.hidesBottomBar) as? Bool ?? false
         }
         set {
             objc_setAssociatedObject(self, AssociatedKeys.hidesBottomBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
         }
     }
     
     private struct AssociatedKeys {
         static let hidesBottomBar = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
     }
 }
 */
