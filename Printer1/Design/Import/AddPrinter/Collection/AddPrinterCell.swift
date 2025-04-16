import UIKit

final class AddPrinterCell: GeneralCollectionCell {
    // MARK: - properties

    private let cornerRadius: CGFloat = 22

    // MARK: - views

    private lazy var blueImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        imageView.image = .apBlue
        return imageView
    }()

    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.numberOfLines = 2
        label.font = .dmSans(.heavy, size: 18)
        label.textColor = .prBlack
        return label
    }()

    private lazy var checkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        imageView.image = .apCheck
        imageView.isHidden = true
        return imageView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.isHidden = true
//        activityIndicator.center = activityView.center
//        activityIndicator.startAnimating()
        return activityIndicator
    }()


    // MARK: - overrides

    override class var size: CGSize {
        let width: CGFloat = screeneWidth - 44
        let height: CGFloat = 68
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
        addSubview(blueImage)
        addSubview(cellLabel)
        addSubview(checkImage)
        addSubview(activityIndicator)

        // MARK: - Add Constraints
        setupConstraints()
    }

    // MARK: - methods

    func setCell(_ data: AddPrinterCellModel) {
        cellLabel.text = data.title
    }

    func setIsSelected(_ isSelected: Bool) {
        if isSelected {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                checkImage.isHidden = false
            }
        } else {
            checkImage.isHidden = true
            activityIndicator.isHidden = true
        }
    }
}

// MARK: - sizes extensions

extension AddPrinterCell {

    func setupConstraints() {

        blueImage.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(25)
        })

        cellLabel.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(50)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(blueImage.snp.trailing).offset(14)
        })

        checkImage.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(14)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        })

        activityIndicator.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(14)
            $0.size.equalTo(32)
            $0.centerY.equalToSuperview()
        })
    }
}
