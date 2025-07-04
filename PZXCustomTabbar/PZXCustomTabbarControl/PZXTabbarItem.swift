import UIKit

/// TabBar 普通项视图：上图标(24x24) + 下标题
class PZXTabbarItem: UIView {
    // MARK: UI
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let badgeView = UIView()
    
    // MARK: 颜色
    private var selectedColor: UIColor = .systemBlue
    private var unselectedColor: UIColor = .gray
    
    // 选中状态
    var isSelected: Bool = false {
        didSet { updateColors() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildUI()
    }
    
    private func buildUI() {
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        titleLabel.font = .systemFont(ofSize: 11)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // 红点
        badgeView.backgroundColor = .systemRed
        badgeView.layer.cornerRadius = 4
        badgeView.isHidden = true
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(badgeView)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4),
            
            // badge 位置：图标右上角
            badgeView.widthAnchor.constraint(equalToConstant: 8),
            badgeView.heightAnchor.constraint(equalToConstant: 8),
            badgeView.centerXAnchor.constraint(equalTo: iconView.trailingAnchor,constant: -4),
            badgeView.centerYAnchor.constraint(equalTo: iconView.topAnchor,constant: 4)
        ])
    }
    
    /// 配置内容
    func configure(title: String, iconName: String, selectedColor: UIColor, unselectedColor: UIColor) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        titleLabel.text = title
        iconView.image = UIImage(systemName: iconName)
        updateColors()
    }
    
    private func updateColors() {
        let color = isSelected ? selectedColor : unselectedColor
        titleLabel.textColor = color
        iconView.tintColor = color
    }
    
    /// 控制红点显隐
    func setBadgeVisible(_ visible: Bool) {
        badgeView.isHidden = !visible
    }
} 
