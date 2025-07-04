# PZXCustomTabBar 说明 / PZXCustomTabBar README

> Swift • No third-party • iOS 13+

---

## 功能概览 (CN)
1. 支持 2~4 个普通 Tab，可选 1 个突出中心按钮（可自定义视图）。
2. 普通 Tab：24×24 图标 + 标题，选中 / 未选中颜色可配置。
3. 红点 Badge：任意 Tab 可显示 / 隐藏 8×8 红点。
4. 代码主动切换 Tab (`selectTab`)、设置红点 (`setBadge`)。
5. 中心按钮支持点击回调，且突出部分也可响应点击。

## Features (EN)
1. 2-4 regular tabs, optional floating **center button** (custom view supported).
2. Regular tab item with 24×24 SF-Symbol icon & title, configurable selected / unselected colors.
3. 8×8 red **badge** can be shown / hidden per tab.
4. Programmatically switch tab (`selectTab`) and toggle badge (`setBadge`).
5. Center button click callback, touch passes through even outside TabBar bounds.

---

## 快速集成 (CN)
```swift
let titles = ["发现","会话","收件箱","我的"]
let icons  = ["map","doc.text","bell","person"]

let discoverVC = UIViewController()
let sessionsVC = UIViewController()
let inboxVC    = UIViewController()
let accountVC  = UIViewController()

// ⭕️ 自定义中心按钮（可选）
let centerBtn = UIButton(type: .custom)
centerBtn.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
centerBtn.backgroundColor = .systemBlue
centerBtn.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
centerBtn.layer.cornerRadius = 32

let tabVC = PZXTabbarViewController(
    viewControllers: [discoverVC,sessionsVC,inboxVC,accountVC],
    titles: titles,
    icons: icons,
    selectedColor: .systemBlue,
    unselectedColor: .gray,
    centerView: centerBtn   // 无中心按钮可传 nil
)
window?.rootViewController = tabVC
```

## Quick Start (EN)
```swift
let titles = ["Discover","Sessions","Inbox","Account"]
let icons  = ["map","doc.text","bell","person"]

let tabVC = PZXTabbarViewController(
    viewControllers: [vc1, vc2, vc3, vc4],
    titles: titles,
    icons: icons,
    selectedColor: .systemBlue,
    unselectedColor: .gray,
    centerView: nil  // pass custom button if needed
)
window?.rootViewController = tabVC
```

---

## 常用 API (CN)
```swift
// 全局获取 TabBarVC
UIApplication.pzxTabbarVC?.selectTab(at: 2)        // 选中第三个
UIApplication.pzxTabbarVC?.setBadge(at: 1, visible: true) // 第二个显示红点
```

## Public API (EN)
```swift
// Global access
UIApplication.pzxTabbarVC?.selectTab(at: 3)        // switch to 4th tab
UIApplication.pzxTabbarVC?.setBadge(at: 0, visible: true) // show badge on first tab
```

---

## FAQ
| Q | A |
|---|---|
| `selectTab` 无效？ | 调用时机需在 TabBar 加载后，例如 `sceneDidBecomeActive`。 |
| 如何只要 3 个 Tab？ | 传 3 个 VC + 3 个标题/图标，`centerView` 传 nil。 |
| 中心按钮无法点击？ | 确认已调用 `bringSubviewToFront(center)`（组件内部已处理）。 |

---

© 2025 KpengS