import UIKit

final class AppLaunch {

    private var window: UIWindow?

    func launch() {
        if UserInfoManager.isNotFirstEnter ?? false {
            startMainScene()
        } else {
            UserInfoManager.isNotFirstEnter = false
            UserInfoManager.isFirstIconSet = true
            welcomeScreen()
        }
    }

    func welcomeScreen() {
        let vc = UINavigationController(rootViewController: WelcomeViewController())
        makeController(vc)
    }

    func startMainScene() {
        let vc = configTabBarVC()
        makeController(vc)
    }

    private func makeController(_ controller: UIViewController) {
        let window = AppDelegate.appDelegate.window ?? UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = .light
        AppDelegate.appDelegate.window = window

        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}

extension AppLaunch {
    private func configTabBarVC() -> UITabBarController {
        let tabBarVC = AppTabBar()
        tabBarVC.viewControllers = [createVC(ImportInit.createViewController()),
                                            createVC(HistoryInit.createViewController()),
                                            createVC(SettingInit.createViewController())
        ]
        return tabBarVC
    }

    func createVC(_ vc: UIViewController) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }
}
