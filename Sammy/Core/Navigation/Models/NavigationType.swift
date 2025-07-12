enum NavigationType {
  case navigate([any NavigationDestination])
  case none
  case presentCover(ModalDestination)
}
