import Foundation

struct Achievement {
    let name: String
    let target: Int
    var progress: Int

    var isCompleted: Bool {
        return progress >= target
    }
}

class GameAchievements {
    static var achievements: [Achievement] = [
        Achievement(name: "First 10 Points", target: 10, progress: 0),
        Achievement(name: "Collector", target: 50, progress: 0),
        Achievement(name: "High Scorer", target: 100, progress: 0)
    ]

    static func loadAchievements() {
        for (index, _) in achievements.enumerated() {
            let progress = UserDefaults.standard.integer(forKey: "achievement_\(index)")
            achievements[index].progress = progress
        }
    }

    static func saveAchievements() {
        for (index, achievement) in achievements.enumerated() {
            UserDefaults.standard.set(achievement.progress, forKey: "achievement_\(index)")
        }
    }

    static func checkAchievements(points: Int, collectibles: Int) {
        achievements[0].progress = points
        achievements[1].progress = collectibles
        achievements[2].progress = max(points, collectibles)

        saveAchievements()
    }
}

