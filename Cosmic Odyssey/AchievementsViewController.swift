import UIKit

class AchievementsViewController: UIViewController {
    var achievements: [GameAchievement] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        let titleLabel = UILabel()
        titleLabel.text = "Achievements"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        for achievement in achievements {
            let achievementLabel = UILabel()
            achievementLabel.numberOfLines = 0 // Allow multiple lines
            achievementLabel.text = "\(achievement.title)\n\(achievement.description) - \(achievement.isUnlocked ? "Unlocked" : "Locked")"
            achievementLabel.textColor = .white
            stackView.addArrangedSubview(achievementLabel)

            // Create progress view
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.progress = Float(achievement.progress) / Float(achievement.goal)
            stackView.addArrangedSubview(progressView)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
