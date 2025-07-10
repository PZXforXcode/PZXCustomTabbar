//
//  DiscoverViewController.swift
//  PZXCustomTabbar
//
//  Created by 彭祖鑫 on 2025/7/4.
//

import UIKit

/// 首页控制器 - Discover页面
class DiscoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBlue
        title = "Discover"
        
        // 创建页面标题
        let titleLabel = UILabel()
        titleLabel.text = "Discover"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 创建中心按钮
        let centerButton = UIButton(type: .system)
        centerButton.setTitle("进入详情页", for: .normal)
        centerButton.setTitleColor(.systemBlue, for: .normal)
        centerButton.backgroundColor = .white
        centerButton.layer.cornerRadius = 25
        centerButton.layer.shadowColor = UIColor.black.cgColor
        centerButton.layer.shadowOpacity = 0.2
        centerButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        centerButton.layer.shadowRadius = 8
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerButton)
        
        // 创建说明标签
        let descriptionLabel = UILabel()
        descriptionLabel.text = "点击下方按钮跳转到详情页\n详情页将自动隐藏TabBar"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.alpha = 0.8
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        // 创建动画控制按钮
        let animationToggleButton = UIButton(type: .system)
        animationToggleButton.setTitle("关闭TabBar点击动画", for: .normal)
        animationToggleButton.setTitleColor(.white, for: .normal)
        animationToggleButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        animationToggleButton.layer.cornerRadius = 20
        animationToggleButton.layer.borderWidth = 1
        animationToggleButton.layer.borderColor = UIColor.white.cgColor
        animationToggleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        animationToggleButton.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
        animationToggleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationToggleButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 标题标签约束
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            // 中心按钮约束
            centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerButton.widthAnchor.constraint(equalToConstant: 180),
            centerButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 说明标签约束
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: centerButton.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 动画控制按钮约束
            animationToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationToggleButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            animationToggleButton.widthAnchor.constraint(equalToConstant: 200),
            animationToggleButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // 私有属性：记录动画状态
    private var isAnimationEnabled = true
    
    @objc private func toggleAnimation() {
        isAnimationEnabled.toggle()
        UIApplication.pzxTabbarVC?.setTapAnimationEnabled(isAnimationEnabled)
        
        // 更新按钮标题
        let buttonTitle = isAnimationEnabled ? "关闭TabBar点击动画" : "开启TabBar点击动画"
        if let button = view.subviews.first(where: { $0 is UIButton && ($0 as? UIButton)?.titleLabel?.text?.contains("TabBar") == true }) as? UIButton {
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    @objc private func centerButtonTapped() {
        let detailVC = DetailViewController()
        // 可以在这里设置，也可以在DetailViewController内部设置
        // 类似系统的 hidesBottomBarWhenPushed
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
} 
