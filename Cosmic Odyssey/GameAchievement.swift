import Foundation

class GameAchievement: Codable {
    var title: String
    var description: String
    var isUnlocked: Bool
    var progress: Int
    var goal: Int

    init(title: String, description: String, isUnlocked: Bool, progress: Int, goal: Int) {
        self.title = title
        self.description = description
        self.isUnlocked = isUnlocked
        self.progress = progress
        self.goal = goal
    }
}
