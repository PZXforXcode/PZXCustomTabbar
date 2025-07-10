//
//  SceneDelegate.swift
//  PZXCustomTabbar
//
//  Created by 彭祖鑫 on 2025/7/4.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // tab 配色
        let selectedColor = UIColor(red: 0.18, green: 0.44, blue: 0.97, alpha: 1.0)
        let unselectedColor = UIColor.gray

        //let selectedColor = UIColor.red
//        let unselectedColor = UIColor.cyan
        
        // 创建自定义的DiscoverViewController并包装在导航控制器中
        let discoverVC = DiscoverViewController()
        let discoverNavVC = UINavigationController(rootViewController: discoverVC)
        
        let sessionsVC = UIViewController()
        sessionsVC.view.backgroundColor = .systemGreen
        sessionsVC.title = "Sessions"
        let sessionsNavVC = UINavigationController(rootViewController: sessionsVC)
        
        let inboxVC = UIViewController()
        inboxVC.view.backgroundColor = .systemOrange
        inboxVC.title = "Inbox"
        let inboxNavVC = UINavigationController(rootViewController: inboxVC)
        
        let accountVC = UIViewController()
        accountVC.view.backgroundColor = .systemPurple
        accountVC.title = "Account"
        let accountNavVC = UINavigationController(rootViewController: accountVC)
        
        // 自定义中心按钮
        let centerBtn = UIButton(type: .custom)
        centerBtn.backgroundColor = selectedColor
        centerBtn.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
        centerBtn.tintColor = .white
        centerBtn.layer.cornerRadius = 32
        centerBtn.frame = CGRect(x: 0, y: 0, width: 64, height: 64) // 固定大小
        
        // 使用重构后的 PZXTabbarViewController 作为根控制器
        let rootVC = PZXTabbarViewController(
            viewControllers: [discoverNavVC, sessionsNavVC, inboxNavVC, accountNavVC],
            titles: ["Discover","Sessions","Inbox","Account"],
            unselectedIcons: ["Discover","Sessions","Inbox","Account"],
            selectedIcons: ["Discover_selected","Sessions_selected","Inbox_selected","Account_selected"],
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            centerView: centerBtn,
            enableTapAnimation: true  // 开启点击动画效果
        )
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        UIApplication.pzxTabbarVC?.selectTab(at: 1)
        UIApplication.pzxTabbarVC?.setBadge(at: 2, visible: true)
//        UIApplication.pzxTabbarVC?.setBadge(at: 3, visible: true)
        
        // 动画控制示例：可以在运行时动态开关动画
        // UIApplication.pzxTabbarVC?.setTapAnimationEnabled(false)  // 关闭动画
        // UIApplication.pzxTabbarVC?.setTapAnimationEnabled(true)   // 开启动画
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

