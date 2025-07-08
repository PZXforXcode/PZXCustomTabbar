//
//  ViewController.swift
//  PZXCustomTabbar
//
//  Created by 彭祖鑫 on 2025/7/4.
//

import UIKit

/// 自定义 TabBar 控制器，可灵活配置子控制器、颜色和中心按钮
class PZXTabbarViewController: UIViewController {
    
    // MARK: - 公有属性
    /// 供外部读取当前选中索引
    private(set) var selectedIndex: Int = 0
    
    // MARK: - 私有属性
    private var viewControllersList: [UIViewController]
    private let titles: [String]
    private let unselectedIcons: [String]
    private let selectedIcons: [String]
    private let selectedColor: UIColor
    private let unselectedColor: UIColor
    private var centerView: UIView?
    
    var tabBar: PZXCustomTabBar!
    private var currentVC: UIViewController?
    
    // MARK: - 初始化
    /// - Parameters:
    ///   - viewControllers: 需要展示的子控制器，顺序即按钮顺序
    ///   - titles: 按钮标题
    ///   - unselectedIcons: 未选中图标
    ///   - selectedIcons:   选中图标
    ///   - selectedColor: 选中状态下的颜色
    ///   - unselectedColor: 未选中状态下的颜色
    ///   - centerView: 可选中心按钮视图
    init(viewControllers: [UIViewController], titles: [String], unselectedIcons: [String], selectedIcons: [String], selectedColor: UIColor, unselectedColor: UIColor, centerView: UIView? = nil) {
        self.viewControllersList = viewControllers
        self.titles = titles
        self.unselectedIcons = unselectedIcons
        self.selectedIcons = selectedIcons
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.centerView = centerView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        switchToIndex(0)
        tabBar.selectItem(at: 0)
        setupNavigationObserver()
    }
    
    private func setupNavigationObserver() {
        // 监听导航控制器的变化
        for vc in viewControllersList {
            if let navController = vc as? UINavigationController {
                navController.delegate = self
            }
        }
    }
    
    /// 根据转场进度更新TabBar位置
    private func updateTabBarForTransition(progress: CGFloat, shouldHideTabBar: Bool, fromHidden: Bool) {
        let hideDistance: CGFloat = 80 + 32 // TabBar 80 + 中心按钮突出 32
        
        if shouldHideTabBar {
            // 要隐藏TabBar：从0移动到完全隐藏
            let translation = progress * hideDistance
            tabBar.transform = CGAffineTransform(translationX: 0, y: translation)
        } else {
            // 要显示TabBar：从隐藏位置移动到0
            let translation = fromHidden ? (1.0 - progress) * hideDistance : 0
            tabBar.transform = CGAffineTransform(translationX: 0, y: translation)
        }
    }
    
    // MARK: - 构建自定义 TabBar
    private func setupTabBar() {
        // 保证数量一致
        let validTitles = titles.count == viewControllersList.count ? titles : viewControllersList.map { $0.title ?? "" }
        let validUnselectedIcons = unselectedIcons.count == viewControllersList.count ? unselectedIcons : Array(repeating: "square", count: viewControllersList.count)
        let validSelectedIcons = selectedIcons.count == viewControllersList.count ? selectedIcons : validUnselectedIcons
        
        tabBar = PZXCustomTabBar(titles: validTitles,
                                 unselectedIcons: validUnselectedIcons,
                                 selectedIcons: validSelectedIcons,
                                 selectedColor: selectedColor,
                                 unselectedColor: unselectedColor,
                                 centerView: centerView)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 80)
        ])
        tabBar.onItemSelected = { [weak self] index in
            self?.switchToIndex(index)
        }
        tabBar.onCenterTapped = { print("中心按钮点击") }
    }
    
    // MARK: - 切换 VC
    private func switchToIndex(_ index: Int) {
        guard index < viewControllersList.count else { return }
        selectedIndex = index
        
        // 移除旧 VC
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        
        // 添加新 VC
        let vc = viewControllersList[index]
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(vc.view, belowSubview: tabBar)
        
        // 设置约束，使视图填充到屏幕底部（包括TabBar区域）
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        vc.didMove(toParent: self)
        currentVC = vc
    }
    
    // MARK: - 对外开放功能
    /// 主动选择某个Tab
    func selectTab(at index: Int) {
        tabBar.selectItem(at: index)
        switchToIndex(index)
    }
    /// 设置某个Tab的红点显隐
    func setBadge(at index: Int, visible: Bool) {
        tabBar.setBadge(at: index, visible: visible)
    }
    

}

// MARK: - UINavigationControllerDelegate
extension PZXTabbarViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let shouldHideTabBar = viewController.pzxHidesBottomBarWhenPushed
        // 计算需要隐藏的距离：TabBar高度 + 中心按钮突出部分
        let hideDistance: CGFloat = 80 + 32 // TabBar 80 + 中心按钮突出 32
        
        if animated, let coordinator = navigationController.transitionCoordinator {
            // 使用转场协调器实现系统级动画
            coordinator.animate(alongsideTransition: { _ in
                self.tabBar.transform = shouldHideTabBar ? CGAffineTransform(translationX: 0, y: hideDistance) : .identity
            }, completion: { context in
                // 处理取消的情况
                if context.isCancelled {
                    let fromVC = context.viewController(forKey: .from)
                    let shouldRestore = fromVC?.pzxHidesBottomBarWhenPushed ?? false
                    self.tabBar.transform = shouldRestore ? CGAffineTransform(translationX: 0, y: hideDistance) : .identity
                }
            })
        } else {
            // 无动画直接设置
            tabBar.transform = shouldHideTabBar ? CGAffineTransform(translationX: 0, y: hideDistance) : .identity
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 确保TabBar状态正确
        let shouldHideTabBar = viewController.pzxHidesBottomBarWhenPushed
        let hideDistance: CGFloat = 80 + 32 // TabBar 80 + 中心按钮突出 32
        tabBar.transform = shouldHideTabBar ? CGAffineTransform(translationX: 0, y: hideDistance) : .identity
    }
}

// MARK: - UIApplication 快捷获取根 TabbarVC
extension UIApplication {
    /// 全局快捷访问自定义 TabBar 控制器
    static var pzxTabbarVC: PZXTabbarViewController? {
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
