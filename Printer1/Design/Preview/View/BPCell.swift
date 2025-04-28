import UIKit

final class BPCell: GeneralCollectionCell {
    // MARK: - properties


    private let iconSize: CGFloat = 28
    // MARK: - views

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = isSmallPhone ? .dmSans(.semibold, size: 16) : .dmSans(.semibold, size: 18)
        label.textColor = .prBlack
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    // MARK: - overrides

    override class var size: CGSize {
        let width: CGFloat = (screeneWidth - 20)/4
        let height: CGFloat = isEnLocal ? 56 : 82
        return CGSize(
            width: width,
            height: height
        )
    }

    override func setup() {
        super.setup()

        backgroundColor = .white

        // MARK: - Add Subviews
        addSubview(iconView)
        addSubview(titleLabel)

        // MARK: - Add Constraints
        setupConstraints()
    }

    // MARK: - methods

    func configCell(_ data: BPCellModel) {
        titleLabel.text = data.title
        iconView.image = data.icon
    }
}

// MARK: - sizes extensions

extension BPCell {

    func setupConstraints() {

        iconView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(iconSize)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(iconView.snp.bottom).offset(4)
        })
    }
}
