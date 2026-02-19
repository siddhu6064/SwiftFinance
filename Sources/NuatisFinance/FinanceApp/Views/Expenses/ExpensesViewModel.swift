import Foundation

struct ExpensesViewModel {
    let thisMonthTotal: String
    let reimbursableTotal: String
    let topCategory: String
    let expenses: [ExpenseItem]

    static let sample = ExpensesViewModel(
        thisMonthTotal: "$6,230",
        reimbursableTotal: "$740",
        topCategory: "Infrastructure",
        expenses: [
            ExpenseItem(description: "AWS Hosting", category: "Infrastructure", amount: "$189", date: "Today"),
            ExpenseItem(description: "Figma Subscription", category: "Software", amount: "$45", date: "Yesterday"),
            ExpenseItem(description: "Client Meeting Lunch", category: "Meals", amount: "$82", date: "2 days ago")
        ]
    )
}

struct ExpenseItem: Identifiable {
    let id = UUID()
    let description: String
    let category: String
    let amount: String
    let date: String
}
