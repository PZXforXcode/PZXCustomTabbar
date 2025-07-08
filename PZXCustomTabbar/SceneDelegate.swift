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
        let inboxVC = UIViewController()
        inboxVC.view.backgroundColor = .systemOrange
        inboxVC.title = "Inbox"
        let accountVC = UIViewController()
        accountVC.view.backgroundColor = .systemPurple
        accountVC.title = "Account"
        
        // 自定义中心按钮
        let centerBtn = UIButton(type: .custom)
        centerBtn.backgroundColor = selectedColor
        centerBtn.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
        centerBtn.tintColor = .white
        centerBtn.layer.cornerRadius = 32
        centerBtn.frame = CGRect(x: 0, y: 0, width: 64, height: 64) // 固定大小
        
        let titles = ["Discover","Sessions","Inbox","Account"]
        let unselectedIcons = ["Discover","Sessions","Inbox","Account"]
        let selectedIcons = ["Discover_selected","Sessions_selected","Inbox_selected","Account_selected"] // 示例：演示用，项目中可替换为 *_selected 资源
        
        let rootVC = PZXTabbarViewController(
            viewControllers: [discoverNavVC, sessionsVC, inboxVC, accountVC],
            titles: titles,
            unselectedIcons: unselectedIcons,
            selectedIcons: selectedIcons,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            centerView: centerBtn)
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

