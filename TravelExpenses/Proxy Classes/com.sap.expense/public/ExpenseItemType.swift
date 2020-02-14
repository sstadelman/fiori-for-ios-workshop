// # Proxy Compiler 18.3.1-fe2cc6-20180517

import Foundation
import SAPOData

final public class ExpenseItemType: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public static var reportid: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "REPORTID")

    public static var itemid: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "ITEMID")

    public static var expensetypeid: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "EXPENSETYPEID")

    public static var itemdate: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "ITEMDATE")

    public static var amount: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "AMOUNT")

    public static var paymenttypeid: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "PAYMENTTYPEID")

    public static var vendor: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "VENDOR")

    public static var location: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "LOCATION")

    public static var currencyid: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "CURRENCYID")

    public static var notes: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "NOTES")

    public static var paymentType: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "paymentType")

    public static var expenseType: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "expenseType")

    public static var currency: Property = TravelexpenseMetadata.EntityTypes.expenseItemType.property(withName: "currency")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: TravelexpenseMetadata.EntityTypes.expenseItemType)
    }

    public var amount: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: ExpenseItemType.amount))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.amount, to: DecimalValue.of(optional: value))
        }
    }

    public class func array(from: EntityValueList) -> Array<ExpenseItemType> {
        return ArrayConverter.convert(from.toArray(), Array<ExpenseItemType>())
    }

    public func copy() -> ExpenseItemType {
        return CastRequired<ExpenseItemType>.from(self.copyEntity())
    }

    public var currency: CurrencyType? {
        get {
            return CastOptional<CurrencyType>.from(self.optionalValue(for: ExpenseItemType.currency))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.currency, to: value)
        }
    }

    public var currencyid: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ExpenseItemType.currencyid))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.currencyid, to: StringValue.of(optional: value))
        }
    }

    public var expenseType: ExpenseType? {
        get {
            return CastOptional<ExpenseType>.from(self.optionalValue(for: ExpenseItemType.expenseType))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.expenseType, to: value)
        }
    }

    public var expensetypeid: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ExpenseItemType.expensetypeid))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.expensetypeid, to: StringValue.of(optional: value))
        }
    }

    public override var isProxy: Bool {
        return true
    }

    public var itemdate: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: ExpenseItemType.itemdate))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.itemdate, to: value)
        }
    }

    public var itemid: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ExpenseItemType.itemid))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.itemid, to: StringValue.of(optional: value))
        }
    }

    public class func key(reportid: String?, itemid: String?) -> EntityKey {
        return EntityKey().with(name: "REPORTID", value: StringValue.of(optional: reportid)).with(name: "ITEMID", value: StringValue.of(optional: itemid))
    }

    public var location: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ExpenseItemType.location))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.location, to: StringValue.of(optional: value))
        }
    }

    public var notes: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ExpenseItemType.notes))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.notes, to: StringValue.of(optional: value))
        }
    }

    public var old: ExpenseItemType {
        return CastRequired<ExpenseItemType>.from(self.oldEntity)
    }

    public var paymentType: PaymentType? {
        get {
            return CastOptional<PaymentType>.from(self.optionalValue(for: ExpenseItemType.paymentType))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.paymentType, to: value)
        }
    }

    public var paymenttypeid: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ExpenseItemType.paymenttypeid))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.paymenttypeid, to: StringValue.of(optional: value))
        }
    }

    public var reportid: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ExpenseItemType.reportid))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.reportid, to: StringValue.of(optional: value))
        }
    }

    public var vendor: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ExpenseItemType.vendor))
        }
        set(value) {
            self.setOptionalValue(for: ExpenseItemType.vendor, to: StringValue.of(optional: value))
        }
    }
}
