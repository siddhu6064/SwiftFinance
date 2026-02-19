import CoreData

extension NSManagedObject {
    func string(_ key: String, default defaultValue: String = "") -> String {
        (value(forKey: key) as? String) ?? defaultValue
    }

    func double(_ key: String, default defaultValue: Double = 0) -> Double {
        (value(forKey: key) as? Double) ?? defaultValue
    }

    func date(_ key: String, default defaultValue: Date = .now) -> Date {
        (value(forKey: key) as? Date) ?? defaultValue
    }
}
