import Combine
import Foundation

public class LoadingManager {
    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)

    public var loadingPublisher: AnyPublisher<Bool, Never> {
        loadingSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public init() { }

    public func showLoading() {
        loadingSubject.send(true)
    }

    public func hideLoading() {
        loadingSubject.send(false)
    }
}
