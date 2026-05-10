import UIKit

final class GaleriaViewController: UIViewController {

    private enum FiltroCuritiba: Int, CaseIterable {
        case todos
        case nascido
        case radicado
        case forteLigacao
        case obraPublica

        var tituloSegmento: String {
            switch self {
            case .todos:
                return "Todos"
            case .nascido:
                return "Nasc."
            case .radicado:
                return "Radic."
            case .forteLigacao:
                return "Ligação"
            case .obraPublica:
                return "Pública"
            }
        }

        var valorJSON: String? {
            switch self {
            case .todos:
                return nil
            case .nascido:
                return "Nascido em Curitiba"
            case .radicado:
                return "Radicado em Curitiba"
            case .forteLigacao:
                return "Forte ligação com Curitiba"
            case .obraPublica:
                return "Obra pública em Curitiba"
            }
        }
    }

    private var obras: [ObraDeArte] = []
    private var obrasFiltradas: [ObraDeArte] = []

    private var filtroSelecionado: FiltroCuritiba = .todos
    private var textoPesquisa: String = ""

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Pesquisar por obra ou artista"
        return searchController
    }()

    private lazy var filtroSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()

        FiltroCuritiba.allCases.forEach { filtro in
            segmentedControl.insertSegment(
                withTitle: filtro.tituloSegmento,
                at: segmentedControl.numberOfSegments,
                animated: false
            )
        }

        segmentedControl.selectedSegmentIndex = FiltroCuritiba.todos.rawValue
        segmentedControl.addTarget(
            self,
            action: #selector(filtroAlterado),
            for: .valueChanged
        )

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            ObraDeArteCell.self,
            forCellWithReuseIdentifier: ObraDeArteCell.reuseIdentifier
        )

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configurarTela()
        carregarDados()
        aplicarFiltros()
        configurarHierarquia()
        configurarConstraints()
    }

    private func configurarTela() {
        title = "Artistas Curitibanos"
        view.backgroundColor = .systemBackground

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    private func carregarDados() {
        obras = ObraDeArteRepository.carregarObras()
        print("Total de obras carregadas: \(obras.count)")
    }

    private func configurarHierarquia() {
        view.addSubview(filtroSegmentedControl)
        view.addSubview(collectionView)
    }

    private func configurarConstraints() {
        NSLayoutConstraint.activate([
            filtroSegmentedControl.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 12
            ),
            filtroSegmentedControl.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            filtroSegmentedControl.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),

            collectionView.topAnchor.constraint(
                equalTo: filtroSegmentedControl.bottomAnchor,
                constant: 12
            ),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func quantidadeDeColunas() -> CGFloat {
        if traitCollection.userInterfaceIdiom == .pad {
            return 4
        }

        return 2
    }

    private func aplicarFiltros() {
        let resultadoPorCriterio = obras.filter { obra in
            guard let valorFiltro = filtroSelecionado.valorJSON else {
                return true
            }

            return obra.criterioCuritiba == valorFiltro
        }

        if textoPesquisa.isEmpty {
            obrasFiltradas = resultadoPorCriterio
        } else {
            obrasFiltradas = resultadoPorCriterio.filter { obra in
                obra.titulo.localizedCaseInsensitiveContains(textoPesquisa) ||
                obra.artista.localizedCaseInsensitiveContains(textoPesquisa)
            }
        }

        collectionView.reloadData()
    }

    @objc private func filtroAlterado() {
        guard let filtro = FiltroCuritiba(
            rawValue: filtroSegmentedControl.selectedSegmentIndex
        ) else {
            return
        }

        filtroSelecionado = filtro
        aplicarFiltros()
    }
}

// MARK: - UICollectionViewDataSource

extension GaleriaViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return obrasFiltradas.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ObraDeArteCell.reuseIdentifier,
            for: indexPath
        ) as? ObraDeArteCell else {
            return UICollectionViewCell()
        }

        let obra = obrasFiltradas[indexPath.item]
        cell.configurar(com: obra)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension GaleriaViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let cell = collectionView.cellForItem(at: indexPath) else {
            abrirDetalheDaObra(at: indexPath)
            return
        }

        UIView.animate(
            withDuration: 0.10,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            cell.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        } completion: { [weak self] _ in
            UIView.animate(
                withDuration: 0.18,
                delay: 0,
                usingSpringWithDamping: 0.65,
                initialSpringVelocity: 0.8,
                options: [.curveEaseOut, .allowUserInteraction]
            ) {
                cell.transform = .identity
            } completion: { [weak self] _ in
                self?.abrirDetalheDaObra(at: indexPath)
            }
        }
    }

    private func abrirDetalheDaObra(at indexPath: IndexPath) {
        let obra = obrasFiltradas[indexPath.item]
        let detalheViewController = DetalheObraViewController(obra: obra)

        navigationController?.pushViewController(
            detalheViewController,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GaleriaViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let colunas = quantidadeDeColunas()

        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let sectionInset = layout?.sectionInset ?? .zero
        let espacamentoEntreItens = layout?.minimumInteritemSpacing ?? 0

        let larguraDisponivel = collectionView.bounds.width
            - sectionInset.left
            - sectionInset.right
            - (espacamentoEntreItens * (colunas - 1))

        let larguraCelula = floor(larguraDisponivel / colunas)

        let alturaImagem = larguraCelula
        let alturaTextos: CGFloat = 80
        let alturaCelula = alturaImagem + alturaTextos

        return CGSize(width: larguraCelula, height: alturaCelula)
    }
}

// MARK: - UISearchResultsUpdating

extension GaleriaViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        textoPesquisa = searchController.searchBar.text ?? ""
        aplicarFiltros()
    }
}
