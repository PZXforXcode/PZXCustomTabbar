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
    private let icons: [String]
    private let selectedColor: UIColor
    private let unselectedColor: UIColor
    private var centerView: UIView?
    
    private var tabBar: PZXCustomTabBar!
    private var currentVC: UIViewController?
    
    // MARK: - 初始化
    /// - Parameters:
    ///   - viewControllers: 需要展示的子控制器，顺序即按钮顺序
    ///   - titles: 按钮标题
    ///   - icons: 按钮图标
    ///   - selectedColor: 选中状态下的颜色
    ///   - unselectedColor: 未选中状态下的颜色
    ///   - centerView: 可选中心按钮视图
    init(viewControllers: [UIViewController], titles: [String], icons: [String], selectedColor: UIColor, unselectedColor: UIColor, centerView: UIView? = nil) {
        self.viewControllersList = viewControllers
        self.titles = titles
        self.icons = icons
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
    }
    
    // MARK: - 构建自定义 TabBar
    private func setupTabBar() {
        // 保证数量一致
        let validTitles = titles.count == viewControllersList.count ? titles : viewControllersList.map { $0.title ?? "" }
        let validIcons = icons.count == viewControllersList.count ? icons : Array(repeating: "square", count: viewControllersList.count)
        
        tabBar = PZXCustomTabBar(titles: validTitles,
                                 icons: validIcons,
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
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
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

