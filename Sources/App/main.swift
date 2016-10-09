import Vapor
import VaporMongo
import HTTP


let drop = Droplet(preparations: [Record.self], providers: [VaporMongo.Provider.self])

drop.get("hello") { request in
    return "Hello world"
}
//// test for mongo add data
//drop.get("record") { requset in
//    return try Record.all().makeNode().converted(to: JSON.self)
//}
//
//drop.post("record") { request in
//    var record = try request.record()
//    try record.save()
//    return record
//}

drop.get { req in
    let lang = req.headers["Accept-Language"]?.string ?? "en"
    return try drop.view.make("welcome", [
        "message": Node.string(drop.localization[lang, "welcome", "title"])
    ])
}

drop.resource("posts", PostController())
drop.resource("records", RecordController())

drop.run()

