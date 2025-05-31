import Combine
import Factory
import Foundation
import SammyData

@Observable
@MainActor
final class AppState {

    // MARK: Dependencies

    @ObservationIgnored
    @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

    @ObservationIgnored
    @Injected(\.userStore) private var userStore: UserStore

    @ObservationIgnored
    @Injected(\.loadingManager) private var loadingManager: LoadingManager

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

    init() {
        setupObservers()
    }

    private func setupObservers() {
        toastManager.toastPublisher
            .sink { [weak self] toast in
                self?.toast = toast
            }
            .store(in: &cancellables)

        loadingManager.loadingPublisher
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
