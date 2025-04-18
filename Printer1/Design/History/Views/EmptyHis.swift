import UIKit

final class EmptyHis: UIView {

//    let iconWidth: CGFloat = switch phoneSize {
//    case .big: 160
//    case .medium: 140
//    case .small: 112
//    }
//    let iconHeight: CGFloat = switch phoneSize {
//    case .big: 126
//    case .medium: 106
//    case .small: 84
//    }

    var didAddSelect: (() -> ())?

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .hisEmpty
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = perevod("No files found")
        label.textColor = .prBlack
        label.font = .dmSans(.heavy, size: 22)
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = perevod("Add your first document")
        label.textColor = .subtitleGray
        label.font = .dmSans(.semibold, size: 16)
        return label
    }()

    private lazy var addButton: GradientButton = {
        let button = GradientButton()
        button.setTitle(perevod("Add documents"))
        button.addTarget(self, action: #selector(tapAdd), for: .touchUpInside)

        button.setCornerRadius(20)

        button.layer.shadowRadius = 18
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = UIColor.gradient1.withAlphaComponent(0.29).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 11)
        button.clipsToBounds = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension EmptyHis {

    @objc func tapAdd() {
        didAddSelect?()
    }

    func setup() {
        backgroundColor = .clear
        layer.cornerRadius = 22

        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        clipsToBounds = false

        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(addButton)

        iconView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(102)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(282)
            $0.height.equalTo(203)
        })

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(iconView.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(28)
            $0.trailing.equalToSuperview().inset(28)
        })

        descLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.trailing.equalToSuperview().inset(28)
        })

        addButton.snp.makeConstraints({
            $0.height.equalTo(addButton.height)
            $0.leading.trailing.equalToSuperview().inset(59)
            $0.top.equalTo(descLabel.snp.bottom).offset(30)
        })
    }
}
