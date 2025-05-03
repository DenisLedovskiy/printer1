import UIKit

protocol InAppPresenterOutputInterface: AnyObject {

}

final class InAppViewController: GeneralViewController {

    private var presenter: InAppPresenterInterface?
    private var router: InAppRouterInterface?

    private let moneyManager = MoneyManager.shared

    // MARK: - UI Propery
    private lazy var bottomButtonsHeight: Double = 20

    private var imageTopInset: Double = switch phoneSize {
    case .small: 130
    case .medium: 190
    case .big: 210
    }

    private var imageHeight: Double = switch phoneSize {
    case .small: (screeneWidth-20) * 1.18
    case .medium: 466
    case .big: screeneWidth * 1.18
    }

    private var titleTopInset: Double = switch phoneSize {
    case .small: isEnLocal ? 30 : 4
    case .medium: isEnLocal ? 60 : 30
    case .big: isEnLocal ? 80 : 50
    }

    private var bottomContinueButtonsInset: Double = switch phoneSize {
    case .small: 40
    case .medium: 56
    case .big: 64
    }

    private var bottomButtonsInset: Double = switch phoneSize {
    case .small: 6
    case .medium: 14
    case .big: 14
    }

    // MARK: - UI

    private let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = .inappBack
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        let style1 = [NSAttributedString.Key.font : UIFont.dmSans(.black, size: 28),
                      NSAttributedString.Key.foregroundColor : UIColor.prBlack]
        let style2 = [NSAttributedString.Key.font : UIFont.dmSans(.black, size: 28),
                      NSAttributedString.Key.foregroundColor : UIColor.prBlue]

        let attributedString1 = NSMutableAttributedString(string: perevod("Print") + " ", attributes: style1)
        let attributedString2 = NSMutableAttributedString(string: perevod("Without Limits"), attributes: style2)
        attributedString1.append(attributedString2)

        label.attributedText = attributedString1
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
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
                NSAttributedString.Key.font: UIFont.dmSans(.semibold, size: 14)
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
                NSAttributedString.Key.font: UIFont.dmSans(.semibold, size: 14)
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
                NSAttributedString.Key.font: UIFont.dmSans(.semibold, size: 14)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(selectPP), for: .touchUpInside)
        return button
    }()

    private lazy var notNowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: perevod("Not now"),
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.subtitleGray,
                NSAttributedString.Key.font: UIFont.dmSans(.semibold, size: 14)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(selectNotNow), for: .touchUpInside)

        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    // MARK: - Init
    init(presenter: InAppPresenterInterface, router: InAppRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil,bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)

        hideTabBar(true)
        hideNavBar(true)

        moneyManager.delegate = self
    }
}

// MARK: - InAppPresenterOutputInterface

extension InAppViewController: InAppPresenterOutputInterface {

}

//MARK: - Action
private extension InAppViewController {

    @objc func tapContinue() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        guard let appHubModel = moneyManager.subscription else { return }
        startSpinner()
        moneyManager.startPurchase(appHubModel)
    }

    @objc func selectPP() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        presenter?.selectPP()
    }

    @objc func selectRestore() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        startSpinner()
        moneyManager.restore()
    }

    @objc func selectTerm() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        presenter?.selectTerm()
    }

    @objc func selectNotNow() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        presenter?.selectClose()
    }
}


// MARK: - UISetup

private extension InAppViewController {
    func customInit() {
        let price = moneyManager.getPrice()
        let duration = moneyManager.getDuration()

        subLabel.text = String(format: perevod("Unlimited prints, faster processing, storage for your documents for %@"), "\(price)\(duration)")

        view.addSubview(backImageView)
        view.addSubview(titleLabel)
        view.addSubview(subLabel)
        view.addSubview(continueButton)

        view.addSubview(ppButton)
        view.addSubview(termButton)
        view.addSubview(restoreButton)
        view.addSubview(notNowButton)

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(titleTopInset)
            $0.leading.trailing.equalToSuperview().inset(20)
        })

        subLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(isSmallPhone ? 2 : 8)
            $0.leading.trailing.equalToSuperview().inset(phoneSize == .big ? 30 : 20)
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

        let space: CGFloat = isEnLocal ? 80 : 6
        let bottomButtonWidth = (screeneWidth - space)/4
        restoreButton.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-bottomButtonsInset)
            $0.leading.equalToSuperview().offset(space/2)
            $0.height.equalTo(bottomButtonsHeight)
        })

        termButton.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-bottomButtonsInset)
            $0.leading.equalTo(restoreButton.snp.trailing)
            $0.height.equalTo(bottomButtonsHeight)
        })

        ppButton.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-bottomButtonsInset)
            $0.leading.equalTo(termButton.snp.trailing)
            $0.height.equalTo(bottomButtonsHeight)
        })

        notNowButton.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-bottomButtonsInset)
            $0.trailing.equalToSuperview().inset(space/2)
            $0.height.equalTo(bottomButtonsHeight)
        })

        if currentLocal.contains("de") {
            restoreButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth + 12)
            })
            termButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth)
            })
            ppButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth)
            })
            notNowButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth)
            })
        } else if currentLocal.contains("fr") {
            restoreButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth - 10)
            })
            termButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth - 10)
            })
            ppButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth - 10)
            })
            notNowButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth + 20)
            })
        } else {
            restoreButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth)
            })
            termButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth)
            })
            ppButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth)
            })
            notNowButton.snp.makeConstraints({
                $0.width.equalTo(bottomButtonWidth)
            })
        }
    }
}

// MARK: - AppHubManagerDelegate

extension InAppViewController: MoneyManagerDelegateDelegate {
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
