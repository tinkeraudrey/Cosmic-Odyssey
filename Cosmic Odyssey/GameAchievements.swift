import Foundation

struct Achievement {
    let name: String
    let description: String
    var isUnlocked: Bool
}

class GameAchievements {
    static var achievements: [Achievement] = [
        Achievement(name: "First Collectible", description: "Collect your first collectible", isUnlocked: false),
        Achievement(name: "Five Collectibles", description: "Collect five collectibles", isUnlocked: false),
        Achievement(name: "High Scorer", description: "Reach a high score of 10", isUnlocked: false)
    ]
    
    static func unlockAchievement(named name: String) {
        if let index = achievements.firstIndex(where: { $0.name == name }) {
            achievements[index].isUnlocked = true
        }
    }
    
    static func checkAchievements(points: Int) {
        if points >= 1 {
            unlockAchievement(named: "First Collectible")
        }
        if points >= 5 {
            unlockAchievement(named: "Five Collectibles")
        }
        if points >= 10 {
            unlockAchievement(named: "High Scorer")
        }
    }
    
    static func loadAchievements() {
        // Load achievements from persistent storage if needed
    }
}
