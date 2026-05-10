import UIKit

final class DetalheObraViewController: UIViewController {

    private let obra: ObraDeArte

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let imagemView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let artistaLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let anoLabel = DetalheObraViewController.criarLabelInformativo()
    private let estiloLabel = DetalheObraViewController.criarLabelInformativo()
    private let criterioLabel = DetalheObraViewController.criarLabelInformativo()

    private let descricaoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private lazy var compartilharButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Compartilhar obra"
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        button.addTarget(
            self,
            action: #selector(compartilharObra),
            for: .touchUpInside
        )
        return button
    }()

    init(obra: ObraDeArte) {
        self.obra = obra
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não foi implementado.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurarTela()
        configurarHierarquia()
        configurarConstraints()
        configurarConteudo()
    }

    private func configurarTela() {
        title = "Detalhes"
        view.backgroundColor = .systemBackground
    }

    private func configurarHierarquia() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(imagemView)
        stackView.addArrangedSubview(tituloLabel)
        stackView.addArrangedSubview(artistaLabel)
        stackView.addArrangedSubview(anoLabel)
        stackView.addArrangedSubview(estiloLabel)
        stackView.addArrangedSubview(criterioLabel)
        stackView.addArrangedSubview(descricaoLabel)
        stackView.addArrangedSubview(compartilharButton)
    }

    private func configurarConstraints() {
        let alturaImagem: CGFloat = traitCollection.userInterfaceIdiom == .pad ? 480 : 320

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            imagemView.heightAnchor.constraint(equalToConstant: alturaImagem),

            compartilharButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configurarConteudo() {
        imagemView.image = UIImage(named: obra.imagemNome)
        tituloLabel.text = obra.titulo
        artistaLabel.text = obra.artista
        anoLabel.text = "Ano: \(obra.ano)"
        estiloLabel.text = "Estilo: \(obra.estilo)"
        criterioLabel.text = "Relação com Curitiba: \(obra.criterioCuritiba)"
        descricaoLabel.text = obra.descricao
    }

    @objc private func compartilharObra() {
        let texto = """
        Conheça a obra "\(obra.titulo)", de \(obra.artista). Explore mais artistas curitibanos e valorize a arte local.
        """

        let activityViewController = UIActivityViewController(
            activityItems: [texto],
            applicationActivities: nil
        )

        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = compartilharButton
            popover.sourceRect = compartilharButton.bounds
        }

        present(activityViewController, animated: true)
    }

    private static func criarLabelInformativo() -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }
}
