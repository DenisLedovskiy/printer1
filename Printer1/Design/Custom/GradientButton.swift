import UIKit

final class GradientButton: UIButton {

    var height: Double {
        return 68
    }

    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.gradient0.cgColor, UIColor.gradient1.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame.size = self.frame.size
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.layer.addSublayer(gradient)
    }

    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        gradient.cornerRadius = radius
    }

    func setTitle(_ title: String) {
        let normalAttributedString = NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font : UIFont.dmSans(.heavy, size: 18)
            ]
        )
        setAttributedTitle(normalAttributedString, for: .normal)
    }

    func setActive(_ isActive: Bool) {
        isUserInteractionEnabled = isActive
        alpha = isActive ? 1 : 0.5
    }
}
