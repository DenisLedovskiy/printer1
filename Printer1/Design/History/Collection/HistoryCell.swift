import UIKit

final class HistoryCell: GeneralCollectionCell {
    // MARK: - properties

    private let cornerRadius: CGFloat = 22

    private let gradColor = UIColor(patternImage: .gradientSample)

    // MARK: - views

    private lazy var paperImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.image = .hisPaper
        return imageView
    }()

    private lazy var moreImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.image = .hisMore
        return imageView
    }()

    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .jacarta(.heavy, size: 19)
        label.textColor = gradColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .dmSans(.heavy, size: 18)
        label.textColor = .prBlack
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSans(.semibold, size: 16)
        label.textColor = .subtitleGray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    // MARK: - overrides

    override class var size: CGSize {
        let width: CGFloat = (screeneWidth - 44 - 16)/2
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
        addSubview(paperImage)
        addSubview(cellLabel)
        addSubview(moreImage)
        addSubview(dateLabel)
        paperImage.addSubview(typeLabel)

        // MARK: - Add Constraints
        setupConstraints()
    }

    // MARK: - methods

    func setCell(_ data: HistoryCellModel) {
        cellLabel.text = data.title
        dateLabel.text = data.date
        if data.type == "" {
            typeLabel.text = "WEB"
        } else {
            typeLabel.text = data.type.uppercased()
        }
    }

}

// MARK: - sizes extensions

extension HistoryCell {

    func setupConstraints() {

        moreImage.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(14)
            $0.top.equalToSuperview().offset(14)
            $0.size.equalTo(27)
        })

        paperImage.snp.makeConstraints({
            $0.width.equalTo(80)
            $0.height.equalTo(97)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(phoneSize == .big ? 20 : 2)
        })

        cellLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.top.equalTo(paperImage.snp.bottom).offset(-4)
        })

        dateLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.top.equalTo(cellLabel.snp.bottom).offset(6)
        })

        typeLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.top.equalToSuperview().offset(45)
        })
    }
}
