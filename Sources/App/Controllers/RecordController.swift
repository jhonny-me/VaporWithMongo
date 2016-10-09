import HTTP
import Vapor

final class RecordController: ResourceRepresentable{
    func index(request: Request) throws -> ResponseRepresentable {
        return try Record.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var record = try request.record()
        try record.save()
        return record
    }
    
    func show(request: Request, record: Record) throws -> ResponseRepresentable {
        return record
    }
    
    func delete(request: Request, record: Record) throws -> ResponseRepresentable {
        try record.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Post.query().delete()
        return JSON([])
    }
    
    func update(request: Request, record: Record) throws -> ResponseRepresentable {
        let new = try request.record()
        var record = record
        record.merge(updates: new)
        try record.save()
        return record
    }
    
    func replace(request: Request, record: Record) throws -> ResponseRepresentable {
        try record.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Record> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
        func record() throws -> Record {
            guard let json = json else { throw Abort.badRequest }
            return try Record(node: json)
        }
}
