
open class RESTResponse<T: Decodable>: HTTPResponse {
    
    // MARK: - Properties
    open var object: T? {
        guard let data = data else { return nil }
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            print("Erro: \(error.localizedDescription)")
            return nil
        }
    }
}
