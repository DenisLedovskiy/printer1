import PanModal
import UIKit

final class ChangeIcon: GeneralViewController {

    let iconsize: CGFloat = switch phoneSize {
    case .big: 185
    case .medium: 165
    case .small: 150
    }

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.close, for: .normal)
        button.setImage(.close, for: .highlighted)
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = perevod("Switch icon")
        label.font = .dmSans(.heavy, size: 22)
        label.textColor = .prBlack
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var appImage1Button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 22
        button.backgroundColor = .clear
        button.setImage(.appImage1, for: .normal)
        button.setImage(.appImage1, for: .highlighted)
        button.addTarget(self, action: #selector(tapIcon1), for: .touchUpInside)

        return button
    }()

    private let icon2View: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .appImage2
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 22
        return imageView
    }()

    private lazy var appImage2Button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(tapIcon2), for: .touchUpInside)
        return button
    }()

    //MARK: -  Lifecicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        congifureConstraits()
        setStartSelect()
    }

}
//MARK: - Private
private extension ChangeIcon  {

    @objc func tapClose() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        close()
    }

    func close() {
        dismiss(animated: true)
    }

    @objc func tapIcon1() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        UserInfoManager.isFirstIconSet = true
        appImage2Button.layer.borderWidth = 0
        appImage1Button.layer.borderWidth = 6
        appImage1Button.layer.borderColor = UIColor.prBlack.cgColor

        UIApplication.shared.setAlternateIconName(nil)
    }

    @objc func tapIcon2() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        UserInfoManager.isFirstIconSet = false
        appImage1Button.layer.borderWidth = 0
        appImage2Button.layer.borderWidth = 6
        appImage2Button.layer.borderColor = UIColor.prBlack.cgColor

        UIApplication.shared.setAlternateIconName("AppIconSecond") { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success!")
            }
        }
    }
}


//MARK: - UI
private extension ChangeIcon {

    func setStartSelect() {
        if UserInfoManager.isFirstIconSet ?? true {
            appImage1Button.layer.borderWidth = 6
            appImage1Button.layer.borderColor = UIColor.prBlack.cgColor
            appImage2Button.layer.borderWidth = 0
        } else {
            appImage2Button.layer.borderWidth = 6
            appImage2Button.layer.borderColor = UIColor.prBlack.cgColor
            appImage1Button.layer.borderWidth = 0
        }
    }

    func congifureConstraits() {
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(appImage1Button)
        view.addSubview(icon2View)
        view.addSubview(appImage2Button)

        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview().inset(60)
        })

        backButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(34)
        })

        appImage1Button.snp.makeConstraints({
            $0.size.equalTo(iconsize)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(22)
        })

        icon2View.snp.makeConstraints({
            $0.size.equalTo(iconsize)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.trailing.equalToSuperview().inset(22)
        })

        appImage2Button.snp.makeConstraints({
            $0.size.equalTo(iconsize)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.trailing.equalToSuperview().inset(22)
        })
    }
}

// MARK: - PanModalPresentable
extension ChangeIcon: PanModalPresentable {
    var shortFormHeight: PanModalHeight {
        .contentHeight(360)
    }

    var panScrollable: UIScrollView? {
        nil
    }

    var panModalBackgroundColor: UIColor {
        .black.withAlphaComponent(0.5)
    }

    var cornerRadius: CGFloat {
        42.0
    }

    var showDragIndicator: Bool { false }
}
