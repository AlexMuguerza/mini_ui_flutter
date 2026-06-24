part of 'min_select.dart';

class _MinSelectFloating<T> extends MinFloatingBase {
  const _MinSelectFloating({
    required super.child,
    required super.controller,
    required this.items,
    required this.filteredItems,
    required this.selectedValue,
    required this.activeIndex,
    required this.onActiveIndexChanged,
    required this.onSelected,
    required this.searchable,
    required this.searchController,
    required this.searchFocusNode,
    required MinUiAnchorSide side,
    this.width,
    this.maxHeight,
    this.searchPlaceholder,
  }) : super(
         side: side,
         openOnTap: false,
         closeOnTapOutside: true,
         closeOnEscape: true,
         animation: MinFloatingAnimation.slideAndFade,
       );

  final List<MinSelectItem<T>> items;
  final List<MinSelectItem<T>> filteredItems;
  final T? selectedValue;
  final int? activeIndex;
  final ValueChanged<int?> onActiveIndexChanged;
  final ValueChanged<int> onSelected;
  final double? width;
  final double? maxHeight;
  final bool searchable;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String? searchPlaceholder;

  @override
  Widget wrapOverlay(BuildContext anchorContext, Widget overlayChild) {
    final theme = MinTheme.maybeOf(anchorContext);
    if (theme == null) return overlayChild;
    return MinTheme(data: theme, child: overlayChild);
  }

  @override
  Widget buildContent(BuildContext context, MinFloatingController controller) {
    final theme = context.theme;
    final flatFiltered = filteredItems.whereType<MinSelectOption<T>>().toList();

    Widget panel = MinCard(
      padding: EdgeInsets.all(theme.spacing.px),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (searchable) ...[
            MinInput(
              controller: searchController,
              focusNode: searchFocusNode,
              placeholder: searchPlaceholder ?? context.minLocale.selectSearchPlaceholder,
              leading: Icon(
                const IconData(0xe800, fontFamily: 'MaterialIcons'),
                size: 16,
              ),
              style: MinInputStyle.ghost(theme),
            ),
            SizedBox(height: theme.spacing.px),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? theme.spacing.s12 * 4,
            ),
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildItems(context, flatFiltered),
              ),
            ),
          ),
        ],
      ),
    );

    if (width != null) {
      panel = SizedBox(width: width, child: panel);
    }

    return panel;
  }

  List<Widget> _buildItems(
    BuildContext context,
    List<MinSelectOption<T>> flatFiltered,
  ) {
    final theme = context.theme;
    final widgets = <Widget>[];
    var flatIndex = 0;

    for (final item in filteredItems) {
      if (item is MinSelectSection<T>) {
        if (widgets.isNotEmpty) {
          widgets.add(
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: theme.spacing.s2),
              color: theme.colors.border,
            ),
          );
        }
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.s3,
              vertical: theme.spacing.s2,
            ),
            child: Text(
              item.label,
              style: theme.typography.small.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
        );
      } else if (item is MinSelectOption<T>) {
        final index = flatIndex;
        final isSelected = item.value == selectedValue;
        final isActive = activeIndex == index;
        widgets.add(
          _MinSelectOptionTile<T>(
            option: item,
            isSelected: isSelected,
            isActive: isActive,
            onHover: () => onActiveIndexChanged(index),
            onTap: () => onSelected(index),
          ),
        );
        flatIndex++;
      }
    }

    return widgets;
  }
}
