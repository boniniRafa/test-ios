import Foundation

protocol RedditTopEntriesListViewModelProtocol {
    func fetchEntries()
}

final class RedditTopEntriesListViewModel {
    weak var controllerDelegate: RedditTopEntriesListViewControllerProtocol?
    private let service: RedditTopEntriesListServiceProtocol
    private let paginationHandler = RedditTopEntriesPaginationHandler()
    
    init(controllerDelegate: RedditTopEntriesListViewControllerProtocol,
         service: RedditTopEntriesListServiceProtocol = RedditTopEntriesListService()) {
        self.service = service
    }
}

extension RedditTopEntriesListViewModel: RedditTopEntriesListViewModelProtocol {
    func fetchEntries() {
        service.fetchTopEntries(paginationHandler) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(redditModel):
                self.paginationHandler.updatePagination(with: redditModel)
                self.controllerDelegate?.displayEntries(from: self.paginationHandler.entriesList)
            case .failure:
                break
            }
        }
    }
}
