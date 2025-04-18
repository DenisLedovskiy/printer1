import UIKit
import WebKit

protocol BrowserVCDelegate: AnyObject {

}

final class BrowserVC: GeneralViewController {

    weak var delegate: BrowserVCDelegate?

    private var keyboardHeight: CGFloat? {
        didSet {
            updateField()
        }
    }

    //MARK: - UI

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        let configuration = WKWebViewConfiguration()
        let myURL = URL(string: "https://www.google.com/")
        if let url = myURL {
            let request = URLRequest(url: url)
            view.load(request)
        }
        view.backgroundColor = .clear
        view.navigationDelegate = self
        return view
    }()

    private lazy var backBtn: UIButton = {
        let button = UIButton()
        button.setImage(.brBack, for: .normal)
        button.setImage(.brBack, for: .highlighted)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = perevod("Browser")
        label.font = .dmSans(.heavy, size: 22)
        label.textColor = .prBlack
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 30
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        view.clipsToBounds = false
        return view
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]

        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 30
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        view.clipsToBounds = false
        return view
    }()

    private lazy var printButton: GradientButton = {
        let button = GradientButton()
        button.setTitle(perevod("Print"))
        button.addTarget(self, action: #selector(tapPrint), for: .touchUpInside)

        button.setCornerRadius(20)

        button.layer.shadowRadius = 18
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = UIColor.gradient1.withAlphaComponent(0.29).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 11)
        button.clipsToBounds = false
        return button
    }()

    private lazy var backBr: UIButton = {
        let button = UIButton()
        button.setImage(.brNavBackOff, for: .normal)
        button.setImage(.brNavBackOff, for: .highlighted)
        button.addTarget(self, action: #selector(tapBrBack), for: .touchUpInside)
        return button
    }()

    private lazy var frwdBr: UIButton = {
        let button = UIButton()
        button.setImage(.brNavForwdOff, for: .normal)
        button.setImage(.brNavForwdOff, for: .highlighted)
        button.addTarget(self, action: #selector(tapBrFrwd), for: .touchUpInside)
        return button
    }()

    private lazy var refreshBr: UIButton = {
        let button = UIButton()
        button.setImage(.brNavRefresh, for: .normal)
        button.setImage(.brNavRefresh, for: .highlighted)
        button.addTarget(self, action: #selector(tapRefresh), for: .touchUpInside)
        return button
    }()

    private let fieldBack: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 31

        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 30
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        view.clipsToBounds = false
        return view
    }()

    private lazy var searchBtn: UIButton = {
        let button = UIButton()
        button.setImage(.brSearch, for: .normal)
        button.setImage(.brSearch, for: .highlighted)
        button.addTarget(self, action: #selector(tapSearch), for: .touchUpInside)
        return button
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.tintColor = .prBlack
        textField.textColor = .prBlack
        textField.font = .dmSans(.heavy, size: 16)
        textField.textAlignment = .natural
        textField.text = "https://www.google.com/"
        return textField
    }()

    //MARK: -  Lifecicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(true)
        hideNavBar(true)
        addObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        congifureConstraits()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK: - Private
private extension BrowserVC {

    @objc func tapBack() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        close()
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }

    @objc func tapPrint() {
        if webView.isLoading {
            return
        }

        let printController = UIPrintInteractionController.shared
        printController.delegate = self
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)

        printController.printPageRenderer = renderer
        printController.printInfo = UIPrintInfo(dictionary: nil)
        printController.printInfo?.outputType = .general
        printController.present(animated: true, completionHandler: nil)
    }

    @objc func tapBrBack() {
        if webView.canGoBack {
            webView.goBack()
            frwdBr.setImage(.brNavForwdOn, for: .normal)
            frwdBr.setImage(.brNavForwdOn, for: .highlighted)
        }
    }

    @objc func tapBrFrwd() {
        if webView.canGoForward {
            webView.goForward()
            backBr.setImage(.brNavBackOn, for: .normal)
            backBr.setImage(.brNavBackOn, for: .highlighted)
        }
    }

    @objc func tapRefresh() {
        webView.reload()
    }

    @objc func tapSearch() {
        view.endEditing(true)
        let myURL = URL(string: textField.text ?? "")
        if let url = myURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    func checkButtons() {
        if webView.canGoBack {
            backBr.setImage(.brNavBackOn, for: .normal)
            backBr.setImage(.brNavBackOn, for: .highlighted)
        } else {
            backBr.setImage(.brNavBackOff, for: .normal)
            backBr.setImage(.brNavBackOff, for: .highlighted)
        }

        if webView.canGoForward {
            frwdBr.setImage(.brNavForwdOn, for: .normal)
            frwdBr.setImage(.brNavForwdOn, for: .highlighted)
        } else {
            frwdBr.setImage(.brNavForwdOff, for: .normal)
            frwdBr.setImage(.brNavForwdOff, for: .highlighted)
        }
    }
}

//MARK: - WebViewDelegate
extension BrowserVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        checkButtons()
        textField.text = webView.url?.absoluteString
        view.endEditing(true)
    }
}

//MARK: - Keyboard functions
extension BrowserVC {

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
    }

    func updateField() {
        if keyboardHeight == 0 {
            fieldBack.snp.remakeConstraints({
                $0.height.equalTo(62)
                $0.leading.trailing.equalToSuperview().inset(22)
                $0.bottom.equalTo(bottomView.snp.top).offset(-20)
            })
        } else {
            fieldBack.snp.remakeConstraints({
                $0.height.equalTo(62)
                $0.leading.trailing.equalToSuperview().inset(22)
                $0.bottom.equalToSuperview().offset(-(10+(keyboardHeight ?? 0)))
            })
        }

    }
}
//MARK: - UI
private extension BrowserVC {

    func congifureConstraits() {

        view.addSubview(webView)
        view.addSubview(topView)
        topView.addSubview(backBtn)
        topView.addSubview(titleLabel)
        view.addSubview(bottomView)
        bottomView.addSubview(backBr)
        bottomView.addSubview(frwdBr)
        bottomView.addSubview(refreshBr)
        bottomView.addSubview(printButton)

        view.addSubview(fieldBack)
        fieldBack.addSubview(searchBtn)
        fieldBack.addSubview(textField)


        topView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalToSuperview().offset(-18)
        })

        backBtn.snp.makeConstraints({
            $0.size.equalTo(27)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(14)
        })

        bottomView.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
        })

        let widthHalf = (((screeneWidth/2) - 12)/2)/2 - 12
        backBr.snp.makeConstraints({
            $0.size.equalTo(24)
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(widthHalf)
        })

        frwdBr.snp.makeConstraints({
            $0.size.equalTo(24)
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalTo(backBr.snp.trailing).offset((widthHalf * 2)-24)
        })

        refreshBr.snp.makeConstraints({
            $0.size.equalTo(24)
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        })

        printButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(18)
            $0.width.equalTo(136)
            $0.height.equalTo(52)
        })

        webView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
            $0.bottom.equalTo(bottomView.snp.top)
        })

        fieldBack.snp.makeConstraints({
            $0.height.equalTo(62)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.bottom.equalTo(bottomView.snp.top).offset(-20)
        })

        searchBtn.snp.makeConstraints({
            $0.size.equalTo(24)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        })

        textField.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        })
    }
}

//MARK: - UIPrintInteractionControllerDelegate
extension BrowserVC: UIPrintInteractionControllerDelegate {}
