import Vapor
import VaporMongo

let drop = Droplet(providers: [VaporMongo.Provider.self])

drop.get("hello") { request in
    return "Hello world"
}

drop.get { req in
    let lang = req.headers["Accept-Language"]?.string ?? "en"
    return try drop.view.make("welcome", [
    	"message": Node.string(drop.localization[lang, "welcome", "title"])
    ])
}

drop.resource("posts", PostController())

drop.run()
