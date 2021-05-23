//
//  QuizCoreDataSource.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

import CoreData

struct QuizCoreDataSource: QuizCoreDataSourceProtocol {

    private let coreDataContext: NSManagedObjectContext

    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
    }

    func fetchQuizzesFromCoreData(filter: FilterSettings) -> [Quiz] {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        var titlePredicate = NSPredicate(value: true)

        if let text = filter.searchText, !text.isEmpty {
            titlePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(CDQuiz.title), text)
        }

        request.predicate = titlePredicate
        do {
            return try coreDataContext.fetch(request).map { Quiz(with: $0)}
        } catch {
            print("Error when fetching quizzes from core data: \(error)")
            return []
        }
    }

    func saveNewQuizzes(_ quizzes: [Quiz]) {
        do {
            let newIds = quizzes.map { $0.id }
            try deleteAllQuizzesExcept(withId: newIds)
        }
        catch {
            print("Error when deleting quizzes from core data: \(error)")
        }
        quizzes.forEach { quiz in
            do {
                let cdQuiz = try fetchQuiz(withId: quiz.id) ?? CDQuiz(context: coreDataContext)
                quiz.populate(cdQuiz, in: coreDataContext)
            } catch {
                print("Error when fetching/creating a quiz: \(error)")
            }
            do {
                try coreDataContext.save()
            } catch {
                print("Error when saving updated quiz: \(error)")
            }
        }
    }

    func deleteQuiz(withId id: Int) {
        guard let quiz = try? fetchQuiz(withId: id) else { return }

        coreDataContext.delete(quiz)

        do {
            try coreDataContext.save()
        } catch {
            print("Error when saving after deletion of quiz: \(error)")
        }

    }

    private func fetchQuiz(withId id: Int) throws -> CDQuiz? {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %u", #keyPath(CDQuiz.identifier), id)

        let cdResponse = try coreDataContext.fetch(request)
        return cdResponse.first
    }

    private func deleteAllQuizzesExcept(withId ids: [Int]) throws {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        request.predicate = NSPredicate(format: "NOT %K IN %@", #keyPath(CDQuiz.identifier), ids)

        let quizzesToDelete = try coreDataContext.fetch(request)
        quizzesToDelete.forEach { coreDataContext.delete($0) }
        try coreDataContext.save()
    }

}
