import UIKit

class GeneralViewController: UIViewController {

    private var activityView: UIView?

    var selectedPrinter: UIPrinter?

    var tabBar: AppTabBar? {
        return self.tabBarController as? AppTabBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .controllerBack
    }
}

//MARK: - Spiner

extension GeneralViewController {
    func startSpinner() {
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = .black.withAlphaComponent(0.2)

        guard let activityView = activityView else {return}
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = activityView.center
        activityIndicator.startAnimating()
        activityView.addSubview(activityIndicator)
        self.view.addSubview(activityView)
    }

    func endSpinner() {
        DispatchQueue.main.async {
            self.activityView?.removeFromSuperview()
            self.activityView = nil
        }
    }
}

//MARK: - Alert

extension GeneralViewController {

    func showErrorAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func showErrorSettingAlert(title: String, message: String) {

        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: perevod("Settings"), style: UIAlertAction.Style.default, handler: { [weak self] _ in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self?.openSettings()
            }))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func openSettings() {
        guard let settings = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settings) else {
            return
        }

        if UIApplication.shared.canOpenURL(settings) {
            UIApplication.shared.open(settings)
        }
    }
}

//MARK: - Tab and Nav bars
extension GeneralViewController {
    func hideTabBar(_ isHide: Bool) {
        tabBar?.hideTabBar(isHide)
    }

    func hideNavBar(_ isHide: Bool) {
        navigationController?.navigationBar.isHidden = isHide
    }
}
