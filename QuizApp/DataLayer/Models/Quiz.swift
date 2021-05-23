struct Quiz: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, category, level, questions
        case imageUrl = "image"
    }

    let id: Int
    let title: String
    let description: String
    let category: QuizCategory
    let level: Int
    let imageUrl: String
    let questions: [Question]

}
