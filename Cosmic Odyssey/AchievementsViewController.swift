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
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        for achievement in achievements {
            let achievementStackView = UIStackView()
            achievementStackView.axis = .vertical
            achievementStackView.alignment = .leading
            achievementStackView.spacing = 5

            let nameStackView = UIStackView()
            nameStackView.axis = .horizontal
            nameStackView.alignment = .center
            nameStackView.spacing = 10

            let nameLabel = UILabel()
            nameLabel.numberOfLines = 0
            nameLabel.text = "\(achievement.title): "
            nameLabel.textColor = .white
            nameStackView.addArrangedSubview(nameLabel)

            let statusLabel = UILabel()
            statusLabel.textColor = achievement.isUnlocked ? .green : .red
            statusLabel.text = achievement.isUnlocked ? "Unlocked" : "Locked"
            nameStackView.addArrangedSubview(statusLabel)

            achievementStackView.addArrangedSubview(nameStackView)

            let descriptionStackView = UIStackView()
            descriptionStackView.axis = .horizontal
            descriptionStackView.alignment = .center
            descriptionStackView.spacing = 10

            let progressLabel = UILabel()
            progressLabel.textColor = .white
            progressLabel.text = "\(achievement.progress)/\(achievement.goal)"
            descriptionStackView.addArrangedSubview(progressLabel)

            let descriptionLabel = UILabel()
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = "\(achievement.description)"
            descriptionLabel.textColor = .white
            descriptionStackView.addArrangedSubview(descriptionLabel)

            achievementStackView.addArrangedSubview(descriptionStackView)

            stackView.addArrangedSubview(achievementStackView)
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
