import UIKit

final class GuideView: UIView {

    var didTap: (() -> ())?

    private let questImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = .guide
        return imageView
    }()

    private let needTitle: UILabel = {
        let label = UILabel()
        label.text = perevod("Need help connecting ")
        label.numberOfLines = 1
        label.textColor = .prBlack
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.font = .dmSans(.heavy, size: 18)
        return label
    }()

    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = perevod("Visit the [FAQ] for step-by-step guidance")
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .subtitleGray
        label.font = .dmSans(.semibold, size: 16)
        return label
    }()

    private lazy var viewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
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

private extension GuideView {

    func setup() {
        backgroundColor = .white
        layer.cornerRadius = 22

        layer.shadowRadius = 23
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.03).cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 4)
        clipsToBounds = false

        addSubview(questImage)
        addSubview(needTitle)
        addSubview(bottomLabel)
        addSubview(viewButton)

        questImage.snp.makeConstraints({
            $0.size.equalTo(24)
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        })

        needTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalTo(questImage.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
        })

        bottomLabel.snp.makeConstraints({
            $0.top.equalTo(needTitle.snp.bottom).offset(3)
            $0.leading.equalTo(questImage.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
        })

        viewButton.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

    @objc func tapButton() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        didTap?()
    }
}
