import UIKit

final class ImportTop: UIView {

    var didSelect: (() -> ())?

    private let bannerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = .impBanner
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    private let bannerTitle: UILabel = {
        let label = UILabel()
        label.text = perevod("No Printer selected")
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.font = .dmSans(.heavy, size: 25)
        return label
    }()

    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .dotGreen
        view.layer.cornerRadius = 5
        return view
    }()

    private let cellDesc: UILabel = {
        let label = UILabel()
        label.text = perevod("No connected")
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.font = .dmSans(.semibold, size: 16)
        return label
    }()

    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        let attribute = [NSAttributedString.Key.font : UIFont.dmSans(.heavy, size: 18),
                         NSAttributedString.Key.foregroundColor : UIColor.prBlack]
        let attributedString = NSMutableAttributedString(string:perevod("Select"), attributes: attribute)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(tapSelect), for: .touchUpInside)
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

    func setPrinterTitle(title: String) {
        setPrinterUI(true)
        bannerTitle.text = title
        cellDesc.text = perevod("Ready to Print")
    }

    func setPrinterUI(_ isPrinterUI: Bool) {
        selectButton.isHidden = isPrinterUI
    }

}

private extension ImportTop {

    func setup() {
        backgroundColor = .controllerBack
        layer.cornerRadius = 20

        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gradient1.withAlphaComponent(0.29).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 11)
        clipsToBounds = false

        addSubview(bannerImage)
        bannerImage.addSubview(bannerTitle)
        bannerImage.addSubview(cellDesc)
        bannerImage.addSubview(dotView)
        addSubview(selectButton)

        bannerImage.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })

        bannerTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(isSmallPhone ? 12 : 21)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(90)
        })

        cellDesc.snp.makeConstraints({
            $0.top.equalTo(bannerTitle.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(34)
            $0.trailing.equalToSuperview().inset(180)
        })

        dotView.snp.makeConstraints({
            $0.centerY.equalTo(cellDesc.snp.centerY)
            $0.size.equalTo(10)
            $0.leading.equalToSuperview().offset(20)
        })

        let width = perevod("Select").width(font: .dmSans(.heavy, size: 18)) + 56
        selectButton.snp.makeConstraints({
            $0.width.equalTo(width)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview().inset(isSmallPhone ? 10 : 18)
            $0.leading.equalToSuperview().offset(20)
        })

        if !isEnLocal {
            selectButton.snp.updateConstraints({
                $0.bottom.equalToSuperview().inset(10)
            })

            bannerTitle.snp.updateConstraints({
                $0.top.equalToSuperview().offset(12)
            })
        }
    }

    @objc func tapSelect() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        didSelect?()
    }
}
