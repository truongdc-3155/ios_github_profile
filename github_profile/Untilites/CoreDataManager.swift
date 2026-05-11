//
//  CoreDataManager.swift
//  github_profile
//
//  Created by dang.chi.truong on 11/5/26.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserEntity")
        container.loadPersistentStores { _, error in
            if let error { fatalError("Core Data error: \(error)") }
        }
        return container
    }()

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveUser(_ user: User) {
        guard !isFavorite(id: user.id) else { return }
        let entity = UserEntity(context: context)
        entity.id = Int64(user.id)
        entity.login = user.login
        entity.avatarUrl = user.avatarUrl
        try? context.save()
    }

    func deleteUser(id: Int) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        guard let results = try? context.fetch(request) else { return }
        results.forEach { context.delete($0) }
        try? context.save()
    }

    func fetchUsers() -> [UserEntity] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    func isFavorite(id: Int) -> Bool {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return (try? context.count(for: request)) ?? 0 > 0
    }
}
