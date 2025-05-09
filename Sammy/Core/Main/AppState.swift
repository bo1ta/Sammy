import Factory
import Foundation
import Combine
import SammyData

@Observable
@MainActor
final class AppState {

    // MARK: State

    enum State {
        case loggedIn
        case loggedOut
        case loading
    }

    private(set) var currentState = State.loggedOut
    private(set) var cancellables = Set<AnyCancellable>()

    // MARK: Dependencies

    @ObservationIgnored
    @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

    @ObservationIgnored
    @Injected(\.navigationCoordinator) private var navigationCoordinator

    @ObservationIgnored
    @Injected(\.userStore) private var userStore: UserStore

    // MARK: Observed properties

    var toast: Toast?
    var progress = 0.0


    // MARK: Setup

    init() {
        setupObservers()
    }

    private func setupObservers() {
        toastManager.toastPublisher
            .sink { [weak self] toast in
                self?.toast = toast
            }
            .store(in: &cancellables)

        userStore.eventPublisher
            .sink { [weak self] event in
                self?.handleUserEvent(event)
            }
            .store(in: &cancellables)
    }

    private func handleUserEvent(_ event: UserStoreEvent) {
        switch event {
        case .didLogin:
            currentState = .loggedIn
        case .didLogout:
            currentState = .loggedOut
        }
    }

    func initialLoad() async {
        guard let _ = await userStore.loadCurrentUser() else {
            currentState = .loggedOut
            return
        }
        currentState = .loggedIn
    }
}
