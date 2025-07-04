import UIKit

/// 自定义 TabBar，支持 2~4 个普通项，可选 1 个中心自定义视图
class PZXCustomTabBar: UIView {
    // 事件回调
    var onItemSelected: ((Int) -> Void)?   // 普通 item 点击，返回 index
    var onCenterTapped: (() -> Void)?      // 中心视图点击
    
    // 颜色
    private let selectedColor: UIColor
    private let unselectedColor: UIColor
    
    // UI
    private let stackView = UIStackView()
    private var items: [PZXTabbarItem] = []
    private var centerView: UIView?
    
    // MARK: - 初始化
    /// - Parameters:
    ///   - titles: 普通项标题数组 (最少2，最多4)
    ///   - icons: 对应 SF Symbol 名称数组，数量需与 titles 相同
    ///   - selectedColor: 选中颜色
    ///   - unselectedColor: 未选中颜色
    ///   - centerView: 可选中心自定义视图（UIButton/UIView），如 nil 则无中心按钮
    init(titles: [String], icons: [String], selectedColor: UIColor, unselectedColor: UIColor, centerView: UIView? = nil) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.centerView = centerView
        super.init(frame: .zero)
        buildUI(titles: titles, icons: icons)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI 构建
    private func buildUI(titles: [String], icons: [String]) {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 8
        
        // stackView
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 创建普通 Item
        for i in 0..<titles.count {
            let item = PZXTabbarItem()
            item.tag = i
            item.configure(title: titles[i], iconName: icons[i], selectedColor: selectedColor, unselectedColor: unselectedColor)
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:))))
            items.append(item)
            stackView.addArrangedSubview(item)
            // 当遍历到中间位置且存在中心按钮时，插入占位spacer
            if i == titles.count/2 - 1, centerView != nil {
                let spacer = UIView()
                spacer.translatesAutoresizingMaskIntoConstraints = false
                spacer.widthAnchor.constraint(equalToConstant: 64).isActive = true // 与中心按钮宽度接近
                stackView.addArrangedSubview(spacer)
            }
        }
        
        // 插入中心视图
        if let center = centerView {
            addSubview(center)
            center.translatesAutoresizingMaskIntoConstraints = false
            let width = center.bounds.width > 0 ? center.bounds.width : 64
            let height = center.bounds.height > 0 ? center.bounds.height : 64
            NSLayoutConstraint.activate([
                center.widthAnchor.constraint(equalToConstant: width),
                center.heightAnchor.constraint(equalToConstant: height),
                center.centerXAnchor.constraint(equalTo: centerXAnchor),
                center.centerYAnchor.constraint(equalTo: topAnchor, constant: 22)
            ])
            bringSubviewToFront(center)
            center.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(centerTapped)))
        }
        // 默认选中第0个
        selectItem(at: 0)
    }
    
    // MARK: - 事件
    @objc private func itemTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag
        selectItem(at: index)
        onItemSelected?(index)
    }
    @objc private func centerTapped() {
        onCenterTapped?()
    }
    
    // MARK: - 选中逻辑
    func selectItem(at index: Int) {
        for (idx, item) in items.enumerated() {
            item.isSelected = (idx == index)
        }
    }
    
    // MARK: - 点击事件穿透，使中心按钮突出部分也能响应
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 如果中心视图存在且点击区域在中心视图中，则返回中心视图
        if let center = centerView {
            let converted = center.convert(point, from: self)
            if center.bounds.contains(converted) {
                return center.hitTest(converted, with: event) ?? center
            }
        }
        return super.hitTest(point, with: event)
    }
    
    // MARK: - Badge 控制
    func setBadge(at index: Int, visible: Bool) {
        guard index < items.count else { return }
        items[index].setBadgeVisible(visible)
    }
} 
