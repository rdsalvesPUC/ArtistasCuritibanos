import UIKit

final class ObraDeArteCell: UICollectionViewCell {

    static let reuseIdentifier = "ObraDeArteCell"

    private let imagemView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistaLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurarVisual()
        configurarHierarquia()
        configurarConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não foi implementado.")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imagemView.image = nil
        tituloLabel.text = nil
        artistaLabel.text = nil

        transform = .identity
        alpha = 1
    }

    func configurar(com obra: ObraDeArte) {
        imagemView.image = UIImage(named: obra.imagemNome)
        tituloLabel.text = obra.titulo
        artistaLabel.text = obra.artista
    }

    private func configurarVisual() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }

    private func configurarHierarquia() {
        contentView.addSubview(imagemView)
        contentView.addSubview(tituloLabel)
        contentView.addSubview(artistaLabel)
    }

    private func configurarConstraints() {
        NSLayoutConstraint.activate([
            imagemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imagemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagemView.heightAnchor.constraint(equalTo: imagemView.widthAnchor),

            tituloLabel.topAnchor.constraint(equalTo: imagemView.bottomAnchor, constant: 8),
            tituloLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tituloLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            artistaLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 4),
            artistaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            artistaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            artistaLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
