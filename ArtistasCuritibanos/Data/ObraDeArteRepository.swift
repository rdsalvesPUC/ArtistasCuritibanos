import Foundation

final class ObraDeArteRepository {

    static func carregarObras() -> [ObraDeArte] {
        guard let url = localizarArquivoObras() else {
            print("Erro: arquivo obras.json não encontrado no Bundle.")
            listarArquivosDoBundle()
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let obras = try JSONDecoder().decode([ObraDeArte].self, from: data)
            return obras
        } catch {
            print("Erro ao carregar ou decodificar obras.json: \(error)")
            return []
        }
    }

    private static func localizarArquivoObras() -> URL? {
        if let url = Bundle.main.url(forResource: "obras", withExtension: "json") {
            return url
        }

        if let url = Bundle.main.url(
            forResource: "obras",
            withExtension: "json",
            subdirectory: "Data"
        ) {
            return url
        }

        return nil
    }

    private static func listarArquivosDoBundle() {
        guard let resourcePath = Bundle.main.resourcePath else {
            print("Não foi possível acessar o resourcePath do Bundle.")
            return
        }

        do {
            let arquivos = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
            print("Arquivos encontrados no Bundle:")
            arquivos.forEach { print("- \($0)") }
        } catch {
            print("Erro ao listar arquivos do Bundle: \(error)")
        }
    }
}
