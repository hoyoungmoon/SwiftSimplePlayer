struct VideoSource {
    let title: String?
    let json: NSDictionary?
    
    init(_ json: NSDictionary!) {
        guard json != nil else {
            self.json = nil
            self.title = "no title"
            return
        }
        self.json = json
        self.title = json["title"] as? String ?? "no title"
    }
}
