import Vapor
import Fluent

final class Record: Model {
	var id: Node?
	var card: String?
	var time: String?
	var amount: Double?
	var type: String?
}

// MARK: NodeConvertible

extension Record {
    convenience init(node: Node, in context: Context) throws {
        self.init()
        id = node["id"]
        card = node["card"]?.string
        time = node["time"]?.string
        amount = node["amount"]?.double
        type = node["type"]?.string
    }

    func makeNode(context: Context) throws -> Node {
        // model won't always have value to allow proper merges, 
        // database defaults to false
        return try Node.init(node:
            [
                "id": id,
                "card": card,
                "time": time,
                "amount": amount,
                "type": type
            ]
        )
    }
}

// MARK: Database Preparations

extension Record: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("record") { users in
            users.id()
            users.string("card")
            users.string("time")
            users.string("type")
            users.double("amount")
            users.bool("completed")
            users.int("order", optional: true)
        }
    }

    static func revert(_ database: Database) throws {
        fatalError("unimplemented \(#function)")
    }
}

// MARK: Merge

extension Record {
    func merge(updates: Record) {
        id = updates.id ?? id
        card = updates.card ?? card
        time = updates.time ?? time
        amount = updates.amount ?? amount
        type = updates.type ?? type
    }
}
