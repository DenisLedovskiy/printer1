import UIKit

final class AppTabBar: UITabBarController {

    // MARK: - Properties

    private let tabIconSize: CGFloat = 24

    // MARK: - UI

    private let tabCustomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]

        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 30
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        view.clipsToBounds = false
        return view
    }()

    private let importIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.image = .importOn
        return imageView
    }()

    private let historyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.image = .historyOff
        return imageView
    }()

    private let settingsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.image = .settingOff
        return imageView
    }()

    private let importLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .dmSans(.heavy, size: 12)
        label.textColor = .prBlack
        label.adjustsFontSizeToFitWidth = true
        label.text = perevod("import")
        return label
    }()

    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .dmSans(.heavy, size: 12)
        label.textColor = .tabUnselect
        label.adjustsFontSizeToFitWidth = true
        label.text = perevod("settings")
        return label
    }()

    private let historyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .dmSans(.heavy, size: 12)
        label.textColor = .tabUnselect
        label.adjustsFontSizeToFitWidth = true
        label.text = perevod("history")
        return label
    }()

    private lazy var importButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapImport), for: .touchUpInside)
        return button
    }()

    private lazy var historyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapHistory), for: .touchUpInside)
        return button
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapSettings), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()

//        if #available(iOS 17.0, *) {
//            traitOverrides.horizontalSizeClass = .compact
//        } else {
//            // Fallback on earlier versions
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func hideTabBar(_ isHidden: Bool) {
        tabCustomView.isHidden = isHidden
        tabBar.isHidden = isHidden
    }

    func setHomeScreen() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        selectedIndex = 0
        importIcon.image = .importOn
        importLabel.textColor = .prBlack
        settingsIcon.image = .settingOff
        settingsLabel.textColor = .tabUnselect
        historyIcon.image = .historyOff
        historyLabel.textColor = .tabUnselect
    }
}

private extension AppTabBar {

    @objc func tapImport() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        selectedIndex = 0
        importIcon.image = .importOn
        importLabel.textColor = .prBlack
        settingsIcon.image = .settingOff
        settingsLabel.textColor = .tabUnselect
        historyIcon.image = .historyOff
        historyLabel.textColor = .tabUnselect
    }

    @objc func tapSettings() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        selectedIndex = 2
        importIcon.image = .importOff
        importLabel.textColor = .tabUnselect
        settingsIcon.image = .settingOn
        settingsLabel.textColor = .prBlack
        historyIcon.image = .historyOff
        historyLabel.textColor = .tabUnselect
    }

    @objc func tapHistory() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        selectedIndex = 1
        importIcon.image = .importOff
        importLabel.textColor = .tabUnselect
        settingsIcon.image = .settingOff
        settingsLabel.textColor = .tabUnselect
        historyIcon.image = .historyOn
        historyLabel.textColor = .prBlack
    }


    func setupTabBarUI() {
        tabBar.backgroundColor = .clear

        view.addSubview(tabCustomView)
        tabCustomView.addSubview(importIcon)
        tabCustomView.addSubview(importLabel)
        tabCustomView.addSubview(settingsIcon)
        tabCustomView.addSubview(settingsLabel)
        tabCustomView.addSubview(historyIcon)
        tabCustomView.addSubview(historyLabel)
        tabCustomView.addSubview(importButton)
        tabCustomView.addSubview(settingsButton)
        tabCustomView.addSubview(historyButton)


        tabCustomView.snp.makeConstraints({
            $0.height.equalTo(isSmallPhone ? 80 : 100)
            $0.bottom.leading.trailing.equalToSuperview()
        })

        historyIcon.snp.makeConstraints({
            $0.size.equalTo(tabIconSize)
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
        })

        historyLabel.snp.makeConstraints({
            $0.top.equalTo(historyIcon.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        })

        historyButton.snp.makeConstraints({
            $0.top.equalTo(historyIcon.snp.top)
            $0.centerX.equalTo(historyIcon.snp.centerX)
            $0.size.equalTo(60)
        })

        let centerCorner: CGFloat = (screeneWidth - tabIconSize)/4
        let halfIcon: CGFloat = tabIconSize/2
        importIcon.snp.makeConstraints({
            $0.size.equalTo(tabIconSize)
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(centerCorner - halfIcon)
        })

        importLabel.snp.makeConstraints({
            $0.top.equalTo(importIcon.snp.bottom).offset(6)
            $0.centerX.equalTo(importIcon.snp.centerX)
        })

        importButton.snp.makeConstraints({
            $0.top.equalTo(importIcon.snp.top)
            $0.centerX.equalTo(importIcon.snp.centerX)
            $0.size.equalTo(60)
        })

        settingsIcon.snp.makeConstraints({
            $0.size.equalTo(tabIconSize)
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().inset(centerCorner - halfIcon)
        })

        settingsLabel.snp.makeConstraints({
            $0.top.equalTo(settingsIcon.snp.bottom).offset(6)
            $0.centerX.equalTo(settingsIcon.snp.centerX)
        })

        settingsButton.snp.makeConstraints({
            $0.top.equalTo(settingsIcon.snp.top)
            $0.centerX.equalTo(settingsIcon.snp.centerX)
            $0.size.equalTo(60)
        })
    }
}
