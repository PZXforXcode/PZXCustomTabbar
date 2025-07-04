//
//  ViewController.swift
//  PZXCustomTabbar
//
//  Created by 彭祖鑫 on 2025/7/4.
//

import UIKit

// 主控制器
class ViewController: UIViewController {
    
    // 自定义底部TabBar
    private let customTabBar = PZXCustomTabBar()
    
    // 子控制器数组（避免与系统同名属性冲突）
    private var pzxChildViewControllers: [UIViewController] = []
    
    // 当前显示的子控制器
    private var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViewControllers()
        setupCustomTabBar()
        // 默认显示第一个Tab
        switchToViewController(at: .discover)
    }
    
    // 初始化所有子控制器
    private func setupChildViewControllers() {
        // Discover - 蓝色背景
        let discoverVC = createViewController(withTitle: "Discover", backgroundColor: UIColor(red: 0.18, green: 0.44, blue: 0.97, alpha: 1.0))
        pzxChildViewControllers.append(discoverVC)
        
        // Sessions - 绿色背景
        let sessionsVC = createViewController(withTitle: "Sessions", backgroundColor: UIColor(red: 0.3, green: 0.85, blue: 0.4, alpha: 1.0))
        pzxChildViewControllers.append(sessionsVC)
        
        // Scan - 灰色背景
        let scanVC = createViewController(withTitle: "Scan", backgroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0))
        pzxChildViewControllers.append(scanVC)
        
        // Inbox - 橙色背景
        let inboxVC = createViewController(withTitle: "Inbox", backgroundColor: UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0))
        pzxChildViewControllers.append(inboxVC)
        
        // Account - 紫色背景
        let accountVC = createViewController(withTitle: "Account", backgroundColor: UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0))
        pzxChildViewControllers.append(accountVC)
    }
    
    // 创建子控制器的辅助方法
    private func createViewController(withTitle title: String, backgroundColor: UIColor) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = backgroundColor
        
        // 添加标题标签
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(label)
        
        // 设置标签约束（居中）
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        
        return vc
    }
    
    // 设置自定义TabBar
    private func setupCustomTabBar() {
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)
        
        // 设置TabBar约束
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 80) // TabBar高度
        ])
        
        // 设置Tab点击回调
        customTabBar.onTabSelected = { [weak self] tabType in
            self?.switchToViewController(at: tabType)
        }
    }
    
    // 切换显示的子控制器
    private func switchToViewController(at tabType: PZXCustomTabBar.TabType) {
        // 移除当前显示的子控制器
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        // 获取要显示的新控制器
        let index = tabType.rawValue
        guard index < pzxChildViewControllers.count else { return }
        
        let newViewController = pzxChildViewControllers[index]
        addChild(newViewController)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(newViewController.view, belowSubview: customTabBar)
        
        // 设置新控制器视图约束
        NSLayoutConstraint.activate([
            newViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            newViewController.view.bottomAnchor.constraint(equalTo: customTabBar.topAnchor)
        ])
        
        newViewController.didMove(toParent: self)
        currentViewController = newViewController
    }
}

