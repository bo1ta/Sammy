import Combine
import Domain
import Foundation

@Observable
@MainActor
final class AppState {
    private let userStore: UserStore

    // MARK: State

    enum State {
        case loggedIn
        case loggedOut
        case loading
        case anonymous
    }

    private(set) var currentState = State.loggedOut
    private(set) var cancellables = Set<AnyCancellable>()

    var isLoggedIn: Bool {
        userStore.isLoggedIn
    }

    // MARK: Observed properties

    var toast: Toast?
    var progress = 0.0
    var isLoading = true

    // MARK: Setup

    init(userStore: UserStore = UserStore.shared) {
        self.userStore = userStore
        setupObservers()
    }

    private func setupObservers() {
        SammyWrapper.shared.toastPublisher
            .sink { [weak self] toast in
                self?.toast = toast
            }
            .store(in: &cancellables)

        SammyWrapper.shared.loadingPublisher
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
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
        case .didAnonymousLogin:
            currentState = .anonymous
        case .didLogout:
            currentState = .loggedOut
        }
    }

    func initialLoad() async {
        await userStore.initialLoad()
    }
}
