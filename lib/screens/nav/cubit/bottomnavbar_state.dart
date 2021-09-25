part of 'bottomnavbar_cubit.dart';

class BottomNavBarState extends Equatable {
  final BottomNavItem selectedItem;
  const BottomNavBarState(
    this.selectedItem,
  );

  @override
  List<Object> get props => [selectedItem];
}
