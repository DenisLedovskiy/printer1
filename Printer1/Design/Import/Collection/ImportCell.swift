import UIKit

final class ImportCell: GeneralCollectionCell {
    private var imageTopInset: Double = switch phoneSize {
    case .small: 6
    case .medium: 22
    case .big: 26
    }

    // MARK: - properties

    private let cornerRadius: CGFloat = 22
    private let iconSize: CGFloat = 58

    // MARK: - views

    private lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        return imageView
    }()

    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .dmSans(.heavy, size: 18)
        label.textColor = .prBlack
        return label
    }()

    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSans(.semibold, size: 16)
        label.textColor = .subtitleGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: - overrides

    override class var size: CGSize {
        let width: CGFloat = (screeneWidth - 44 - 16)/2
        let height: CGFloat = switch phoneSize {
        case .big: width - 20
        case .medium: width
        case .small: width - 10
        }
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
        addSubview(cellImage)
        addSubview(cellLabel)
        addSubview(subLabel)

        // MARK: - Add Constraints
        setupConstraints()
    }

    // MARK: - methods

    func setCell(_ data: ImportCellModel) {
        cellLabel.text = data.title
        subLabel.text = data.desc
        cellImage.image = data.image
    }

}

// MARK: - sizes extensions

extension ImportCell {

    func setupConstraints() {

        cellImage.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(imageTopInset)
            $0.size.equalTo(iconSize)
        })

        cellLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(cellImage.snp.bottom).offset(14)
        })

        subLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(cellLabel.snp.bottom).offset(3)
        })
    }
}
