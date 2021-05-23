import Foundation

struct Question: Decodable, Hashable {

    let id: Int
    let question: String
    let answers: [String]
    let correctAnswer: Int

    enum CodingKeys: String, CodingKey {
        case id, question, answers
        case correctAnswer = "correct_answer"
    }
}
