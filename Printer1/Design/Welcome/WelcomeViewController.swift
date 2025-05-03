import UIKit
import StoreKit
import SafariServices

final class WelcomeViewController: GeneralViewController {

    private let appHubManager = MoneyManager.shared

    private var page = 0
    private lazy var bottomButtonsHeight: Double = 20

    private var imageTopInset: Double = switch phoneSize {
    case .small: 130
    case .medium: 190
    case .big: 210
    }

    private var imageHeight: Double = switch phoneSize {
    case .small: (screeneWidth-20) * 1.18 //1.18575064
    case .medium: 466
    case .big: screeneWidth * 1.18
    }

    private var titleTopInset: Double = switch phoneSize {
    case .small: isEnLocal ? 30 : 10
    case .medium: isEnLocal ? 60 : 30
    case .big: isEnLocal ? 80 : 50
    }

//    private var bottomContinueButtonsInset: Double = switch phoneSize {
//    case .small: 40
//    case .medium: 56
//    case .big: 64
//    }

    private var bottomButtonsInset: Double = switch phoneSize {
    case .small: 6
    case .medium: 14
    case .big: 14
    }

    //MARK: - UI
    private let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let startSubLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .subtitleGray
        label.font = .dmSans(.semibold, size: 16)
        return label
    }()

    private lazy var continueButton: GradientButton = {
        let button = GradientButton()
        button.setTitle(perevod("Continue"))
        button.addTarget(self, action: #selector(tapContinue), for: .touchUpInside)

        button.setCornerRadius(20)

        button.layer.shadowRadius = 18
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = UIColor.gradient1.withAlphaComponent(0.29).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 11)
        button.clipsToBounds = false
        return button
    }()

    private lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: perevod("Restore"),
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.subtitleGray,
                NSAttributedString.Key.font : UIFont.dmSans(.semibold, size: 14)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(selectRestore), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    private lazy var termButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: perevod("Terms"),
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.subtitleGray,
                NSAttributedString.Key.font : UIFont.dmSans(.semibold, size: 14)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(selectTerm), for: .touchUpInside)
        return button
    }()

    private lazy var ppButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: perevod("Privacy"),
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.subtitleGray,
                NSAttributedString.Key.font : UIFont.dmSans(.semibold, size: 14)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(selectPP), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        hideTabBar(true)
        hideNavBar(true)
        appHubManager.delegate = self
    }
}

//MARK: - Action
private extension WelcomeViewController {

    @objc func tapContinue() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        page += 1

        if page == 2 {
            getAppHudInfoAgain()
        }

        if page == 3 {
            rateApp()
        }

        if page < 4 {
            setUI(page)
        } else {
            openPayWall()
        }
    }

    @objc func selectPP() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        guard let url = URL(string: Config.privacy.rawValue) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }

    @objc func selectRestore() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        startSpinner()
        appHubManager.restore()
    }

    @objc func selectTerm() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        guard let url = URL(string: Config.term.rawValue) else {
          return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}

//MARK: - Private
private extension WelcomeViewController{

    func setUI(_ index: Int) {
        setTitle(index)
        switch index {
        case 0: startSubLabel.text = perevod("Print photos, documents, and web pages directly from your phone")
        case 1: startSubLabel.text = perevod("We’ll automatically find your printer and connect in seconds")
        case 2: startSubLabel.text = perevod("Scan your documents in high quality with just one tap")
        case 3: startSubLabel.text = perevod("We appreciate your feedback and strive to improve our product")
        default: return
        }
        backImageView.image = UIImage(named: "start.\(index)")
    }

    func rateApp() {
        if let scene = UIApplication.shared.currentScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview()
            }
        }
    }

    func openPayWall() {
        let controller = InAppInit.createViewController()
        navigationController?.pushViewController(controller, animated: false)
    }

    func getAppHudInfoAgain() {
        Task {
            MoneyManager.shared.getProducts()
        }
    }
}

//MARK: - Constraits and UI
private extension WelcomeViewController {
    func customInit() {
        navigationController?.navigationBar.isHidden = true
        makeConstraits()
        setUI(page)
    }

    func makeConstraits() {
        view.addSubview(backImageView)
        view.addSubview(titleLabel)
        view.addSubview(startSubLabel)
        view.addSubview(continueButton)

        view.addSubview(ppButton)
        view.addSubview(termButton)
        view.addSubview(restoreButton)

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(titleTopInset)
            $0.leading.trailing.equalToSuperview().inset(10)
        })

        startSubLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(isSmallPhone ? 2 : 8)
            $0.leading.trailing.equalToSuperview().inset(isSmallPhone ? 20 : 40)
        })

        backImageView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(imageTopInset)
            $0.leading.trailing.equalToSuperview().inset(isSmallPhone ? 10 : 0)
            $0.height.equalTo(imageHeight)
        })

        continueButton.snp.makeConstraints({
            $0.top.equalTo(backImageView.snp.bottom).offset(0)
            $0.height.equalTo(continueButton.height)
            $0.leading.trailing.equalToSuperview().inset(22)
        })

        let space: CGFloat = isEnLocal ? 120 : 20
        let buttWidth = (screeneWidth - space)/3
        restoreButton.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-bottomButtonsInset)
            $0.leading.equalToSuperview().offset(space/2)
            $0.height.equalTo(bottomButtonsHeight)
            $0.width.equalTo(buttWidth - 10)
        })

        termButton.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-bottomButtonsInset)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(bottomButtonsHeight)
            $0.width.equalTo(buttWidth + 10)
        })

        ppButton.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-bottomButtonsInset)
            $0.trailing.equalToSuperview().inset(space/2)
            $0.height.equalTo(bottomButtonsHeight)
            $0.width.equalTo(buttWidth - 10)
        })
    }

    private func setTitle(_ index: Int) {
        let style1 = [NSAttributedString.Key.font : UIFont.dmSans(.black, size: 28),
                      NSAttributedString.Key.foregroundColor : UIColor.prBlack]
        let style2 = [NSAttributedString.Key.font : UIFont.dmSans(.black, size: 28),
                      NSAttributedString.Key.foregroundColor : UIColor.prBlue]

        let title1 = switch index {
        case 0: perevod("Print with")
        case 1: perevod("Auto Printer")
        case 2: perevod("Scan")
        case 3: perevod("Trusted")
        default: ""
        }

        let title2 = switch index {
        case 0: perevod("Ease")
        case 1: perevod("Detection")
        case 2: perevod("documents")
        case 3: perevod("by users")
        default: ""
        }

        if page == 2 {
            let attributedString1 = NSMutableAttributedString(string: title1 + " ", attributes: style2)
            let attributedString2 = NSMutableAttributedString(string: title2, attributes: style1)
            attributedString1.append(attributedString2)
            titleLabel.attributedText = attributedString1
        } else {
            let attributedString1 = NSMutableAttributedString(string: title1 + " ", attributes: style1)
            let attributedString2 = NSMutableAttributedString(string: title2, attributes: style2)
            attributedString1.append(attributedString2)
            titleLabel.attributedText = attributedString1
        }


    }
}

// MARK: - AppHubManagerDelegate

extension WelcomeViewController: MoneyManagerDelegateDelegate {
    func purchasesWasEnded(success: Bool?, messageError: String) {
        endSpinner()
        guard let success = success else {
            return
        }

        if !success {
            showErrorAlert(title: perevod("Sorry"), message: messageError)
        }
    }
}
