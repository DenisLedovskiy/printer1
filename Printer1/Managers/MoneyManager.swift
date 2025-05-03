import Foundation
import StoreKit
import ApphudSDK

protocol MoneyManagerDelegateDelegate {
    func purchasesWasEnded(success: Bool?, messageError: String)
}

final class MoneyManager: NSObject {

    static let shared = MoneyManager()
    @objc dynamic var isLoadInapp = false

    @objc private(set) var products: [SKProduct] = []
    private var productIds : Set<String> = []

    var subscription: ApphudProduct?
    private var product: Product?
    var isPremium: Bool { Apphud.hasActiveSubscription() }

    var isSubscribed: Bool = false
    var delegate: MoneyManagerDelegateDelegate?

    private override init() {
        super.init()
    }
}

extension MoneyManager {

    func getProducts() {
        Task {
            let paywall = await Apphud.placements(maxAttempts: 3).filter { $0.identifier == "main"}.first?.paywall
            let product = try await paywall?.products.first?.product()
            subscription = paywall?.products.first
            self.product = product
        }
    }

    func startPurchase(_ product: ApphudProduct) {
        Task {
            let result = await Apphud.purchase(product)
            if result.success {
                delegate?.purchasesWasEnded(success: true, messageError: "")
            } else {
                let errorMess = result.error?.localizedDescription
                guard errorMess != "The operation couldn’t be completed. (SKErrorDomain error 2.)" else {
                    self.delegate?.purchasesWasEnded(success: nil, messageError: "")
                    return
                }
                delegate?.purchasesWasEnded(success: false, messageError: result.error?.localizedDescription ?? "Error during subscription payment process")
            }
        }
    }

    func restore() {
        Task {
            await Apphud.restorePurchases()
            if Apphud.hasActiveSubscription(){
                delegate?.purchasesWasEnded(success: true, messageError: "")
            } else {
                delegate?.purchasesWasEnded(success: false, messageError: "No active subscription found")
            }
        }
    }
}

extension MoneyManager {

    func getPrice() -> String {
        let currency =  getCurrency()
        let price = subscription?.skProduct?.price.formattedCurrency() ?? ""
        return "\(currency)\(price)"
    }

    func getCurrency() -> String {
        guard let subscription = subscription else {return ""}
        return subscription.skProduct?.priceLocale.currencySymbol ?? ""
    }

    func getDuration() -> String {
        let durationUnit = product?.subscription?.subscriptionPeriod.unit
        let durationString: String = switch durationUnit {
        case .day: perevod("/week")
        case .year: perevod("/year")
        case .week: perevod("/week")
        case .month: perevod("/month")
        case .none: ""
        case .some(_): ""
        }
        return durationString
    }
}

extension NSDecimalNumber {

    func formattedCurrency() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter.string(from: NSNumber(value: Double("\(self)") ?? 0))
    }
}
