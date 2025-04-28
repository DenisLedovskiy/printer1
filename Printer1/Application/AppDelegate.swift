import UIKit
import SnapKit
import ApphudSDK
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appLaunch = AppLaunch()
    var window: UIWindow?

    static var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("not open appdelegate")
        }
        return appDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Task {
            Apphud.start(apiKey: Config.appHud.rawValue)
            MoneyManager.shared.getProducts()
        }

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
        application.registerForRemoteNotifications()

        FirebaseApp.configure()

        appLaunch.launch()
        return true
    }
}

//MARK: - Local Push
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Apphud.submitPushNotificationsToken(token: deviceToken, callback: nil)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        dump(error)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Apphud.handlePushNotification(apsInfo: response.notification.request.content.userInfo)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Apphud.handlePushNotification(apsInfo: notification.request.content.userInfo)
        completionHandler([])
    }
}

