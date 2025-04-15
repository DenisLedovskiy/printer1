import UIKit

final class AppLaunch {

    private var window: UIWindow?

    func launch() {
        welcomeScreen()

//        if UserSet.isNotFirstEnter ?? false {
//            startMainScene()
//        } else {
//            UserSet.isShowedLikeIt = false
//            UserSet.isFirstIconSet = true
//            UserSet.isWasSuccesMove = false
//            goOnboardingScreen()
//        }
    }

    func welcomeScreen() {
        let vc = UINavigationController(rootViewController: WelcomeViewController())
        makeController(vc)
    }

//    func startMainScene() {
//        let vc = makeTabBarController()
//        showController(vc)
//    }

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
//    private func makeTabBarController() -> UITabBarController {
//        let tabBarController = PTabBar()
//        tabBarController.viewControllers = [createVC(MainInit.createViewController()),
//                                            createVC(SettingsInit.createViewController())
//        ]
//        return tabBarController
//    }
//
//    func createVC(_ vc: UIViewController) -> UIViewController {
//        let navigationController = UINavigationController(rootViewController: vc)
//        return navigationController
//    }
}
