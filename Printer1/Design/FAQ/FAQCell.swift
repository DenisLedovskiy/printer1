import UIKit

final class FAQCell: GeneralCollectionCell {

    var didTapLink: (()->())?
    // MARK: - properties

    private let cornerRadius: CGFloat = 22

    // MARK: - views

    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.font = .dmSans(.heavy, size: 18)
        label.textColor = .prBlack
        return label
    }()

    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSans(.semibold, size: 16)
        label.textColor = .subtitleGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - overrides

    override class var size: CGSize {
        let width: CGFloat = screeneWidth - 44
        let height: CGFloat = width
        return CGSize(
            width: width,
            height: height
        )
    }

    override func setup() {
        super.setup()

        backgroundColor = .white
        layer.cornerRadius = cornerRadius

        layer.shadowRadius = 16
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.043).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        clipsToBounds = false

        // MARK: - Add Subviews
        addSubview(cellLabel)
        addSubview(subLabel)

        // MARK: - Add Constraints
        setupConstraints()
    }

    // MARK: - methods

    func setCell(_ data: FAQCellModel) {
        cellLabel.text = data.title
        if data.texts.count > 1 {
            setupText(data.texts)
        } else if data.link != nil {
            setWithLink(text: data.texts.first ?? "", link: data.link ?? "")
        } else {
            setUsual(text: data.texts.first ?? "")
        }
    }
}

// MARK: - sizes extensions

extension FAQCell {

    func setupConstraints() {
        cellLabel.snp.remakeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(20)
        })
    }

    func setupText(_ texts: [String]) {
        var labels = [UILabel]()
        for index in 0...texts.count-1 {
            let label = UILabel()
            label.font = .dmSans(.semibold, size: 16)
            label.textColor = .prBlack
            label.textAlignment = .natural
            label.numberOfLines = 0
            label.text = texts[index]
            addSubview(label)

            let number = UILabel()
            number.font = .dmSans(.semibold, size: 16)
            number.textColor = .prBlack
            number.textAlignment = .natural
            number.numberOfLines = 1
            number.text = "\(index+1). "

            addSubview(number)

            if index == 0 {
                label.snp.makeConstraints({
                    $0.leading.equalToSuperview().offset(40)
                    $0.trailing.equalToSuperview().inset(20)
                    $0.top.equalTo(cellLabel.snp.bottom).offset(6)
                })
            } else {
                label.snp.makeConstraints({
                    $0.leading.equalToSuperview().offset(40)
                    $0.trailing.equalToSuperview().inset(20)
                    $0.top.equalTo(labels[index-1].snp.bottom).offset(2)
                })
            }

            if index == texts.count - 1 {
                label.snp.makeConstraints({
                    $0.bottom.equalToSuperview().inset(20)
                })
            }

            number.snp.makeConstraints({
                $0.top.equalTo(label.snp.top)
                $0.trailing.equalTo(label.snp.leading)
            })

            labels.append(label)
        }
    }

    func setWithLink(text: String, link: String) {
        let label = UILabel()
        label.textAlignment = .natural
        label.numberOfLines = 0

        addSubview(label)

        let style1 = [NSAttributedString.Key.font : UIFont.dmSans(.semibold, size: 16),
                      NSAttributedString.Key.foregroundColor : UIColor.prBlack]
        let style2 = [NSAttributedString.Key.font : UIFont.dmSans(.semibold, size: 16),
                      NSAttributedString.Key.foregroundColor : UIColor.link]


        let attributedString1 = NSMutableAttributedString(string: text + " ", attributes: style1)
        let attributedString2 = NSMutableAttributedString(string: link, attributes: style2)
        attributedString1.append(attributedString2)
        label.attributedText = attributedString1

        label.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(cellLabel.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().inset(20)
        })

        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapLink), for: .touchUpInside)

        addSubview(button)
        button.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(20)
        })
    }

    @objc func tapLink() {
        didTapLink?()
    }

    func setUsual(text: String) {
        let label = UILabel()
        label.font = .dmSans(.semibold, size: 16)
        label.textColor = .prBlack
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.text = text

        addSubview(label)

        label.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(cellLabel.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().inset(20)
        })
    }
}
