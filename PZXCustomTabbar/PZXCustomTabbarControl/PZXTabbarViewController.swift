//
//  ViewController.swift
//  PZXCustomTabbar
//
//  Created by 彭祖鑫 on 2025/7/4.
//

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
    init(viewControllers: [UIViewController], titles: [String], unselectedIcons: [String], selectedIcons: [String], selectedColor: UIColor, unselectedColor: UIColor, centerView: UIView? = nil) {
        self.titles = titles
        self.unselectedIcons = unselectedIcons
        self.selectedIcons = selectedIcons
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.centerView = centerView
        super.init(nibName: nil, bundle: nil)
        
        // 直接将子控制器设置给父类
        self.viewControllers = viewControllers
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }
    
    // MARK: - 构建自定义 TabBar
    private func setupCustomTabBar() {
        // 1. 初始化我们自定义的 UIView
        pzx_customTabBar = PZXCustomTabBar(
            titles: titles,
            unselectedIcons: unselectedIcons,
            selectedIcons: selectedIcons,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            centerView: centerView
        )
        
        // 2. 设置回调：当自定义视图中的按钮被点击时，切换 UITabBarController 的 selectedIndex
        pzx_customTabBar.onItemSelected = { [weak self] index in
            self?.selectedIndex = index
        }
        
        // 3. 中心按钮点击回调
        pzx_customTabBar.onCenterTapped = {
            print("中心按钮点击")
        }
        
        // 4. 初始化我们自定义的 UITabBar 子类，并将自定义的 UIView 传入
        let tabBar = PZXTabBar(customTabBarView: pzx_customTabBar)
        
        // 5. 【关键】通过 KVC 将系统原生的 tabBar 替换为我们自定义的 tabBar
        self.setValue(tabBar, forKey: "tabBar")
        
        // 6. 默认选中第一个
        selectTab(at: 0)
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
