import UIKit

final class SettingCell: GeneralCollectionCell {
    // MARK: - properties

    private let cornerRadius: CGFloat = 20
    private let iconSize: CGFloat = 32

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
        label.font = .dmSans(.heavy, size: 18)
        label.textColor = .prBlack
        label.textAlignment = .natural
        label.numberOfLines = 1
        return label
    }()

    // MARK: - overrides

    override class var size: CGSize {
        let width: CGFloat = screeneWidth - 44
        let height: CGFloat = 72
        return CGSize(
            width: width,
            height: height
        )
    }

    override func setup() {
        super.setup()

        backgroundColor = .white
        layer.cornerRadius = cornerRadius

        layer.shadowRadius = cornerRadius
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        clipsToBounds = false

        // MARK: - Add Subviews
        addSubview(iconView)
        addSubview(titleLabel)

        // MARK: - Add Constraints
        setupConstraints()
    }

    // MARK: - methods

    func configCell(_ data: SettingCellModel) {
        titleLabel.text = data.title
        iconView.image = data.icon
    }

}

// MARK: - sizes extensions

extension SettingCell {

    func setupConstraints() {

        iconView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(27)
            $0.size.equalTo(iconSize)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(iconView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        })
    }
}
