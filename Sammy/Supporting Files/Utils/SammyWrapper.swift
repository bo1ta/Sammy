import Combine
import SwiftUI

public class SammyWrapper {
    private static var standardDuration: TimeInterval { 1.5 }

    public static let shared = SammyWrapper()

    private let toastSubject = CurrentValueSubject<Toast?, Never>(nil)
    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)

    public var toastPublisher: AnyPublisher<Toast?, Never> {
        toastSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public var loadingPublisher: AnyPublisher<Bool, Never> {
        loadingSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func show(_ toast: Toast, autoDismissAfter seconds: TimeInterval = 0.3) {
        toastSubject.send(toast)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            self?.toastSubject.send(nil)
        }
    }

    public static func showInfo(_ message: String) {
        shared.show(.info(message), autoDismissAfter: Self.standardDuration)
    }

    public static func showWarning(_ message: String) {
        shared.show(.warning(message), autoDismissAfter: Self.standardDuration)
    }

    public static func showSuccess(_ message: String) {
        shared.show(.success(message), autoDismissAfter: Self.standardDuration)
    }

    public static func showError(_ message: String) {
        shared.show(.error(message), autoDismissAfter: Self.standardDuration)
    }

    public static func showLoading() {
        shared.loadingSubject.send(true)
    }

    public static func hideLoading() {
        shared.loadingSubject.send(false)
    }
}
