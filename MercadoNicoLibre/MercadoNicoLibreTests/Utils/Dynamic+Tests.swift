
@testable import MercadoNicoLibre

extension Dynamic {
    func bindForTests(_ listener: Listener?) {
        forceCurrentThread = true
        self.listener = listener
    }
}
