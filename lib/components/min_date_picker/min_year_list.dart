part of 'min_date_picker.dart';

class _MinYearPopoverButton extends StatelessWidget {
  const _MinYearPopoverButton({
    required this.groupId,
    required this.monthName,
    required this.year,
    required this.minYear,
    required this.maxYear,
    required this.onSelectYear,
  });

  final Object groupId;
  final String monthName;
  final int year;
  final int minYear;
  final int maxYear;
  final ValueChanged<int> onSelectYear;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return MinPopover(
      width: theme.spacing.s12 * 2.5,
      closeOnScroll: false,
      groupId: groupId,
      content: (context, controller) {
        return _YearList(
          minYear: minYear,
          maxYear: maxYear,
          selectedYear: year,
          onSelectYear: (selectedYear) {
            onSelectYear(selectedYear);
            controller.hide();
          },
        );
      },
      child: MinCard(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.s2),
        height: theme.spacing.s10 - theme.spacing.s1,
        backgroundColor: theme.colors.card,
        borderColor: theme.colors.border,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              monthName,
              style: theme.typography.body.copyWith(
                color: theme.colors.cardForeground,
              ),
            ),
            SizedBox(width: theme.spacing.s2),
            Text(
              '$year',
              style: theme.typography.body.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearList extends StatefulWidget {
  const _YearList({
    required this.minYear,
    required this.maxYear,
    required this.selectedYear,
    required this.onSelectYear,
  });

  final int minYear;
  final int maxYear;
  final int selectedYear;
  final ValueChanged<int> onSelectYear;

  @override
  State<_YearList> createState() => _YearListState();
}

class _YearListState extends State<_YearList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _centerSelectedYear());
  }

  @override
  void didUpdateWidget(covariant _YearList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedYear != widget.selectedYear ||
        oldWidget.minYear != widget.minYear ||
        oldWidget.maxYear != widget.maxYear) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _centerSelectedYear(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _centerSelectedYear() {
    if (!mounted || !_scrollController.hasClients) {
      return;
    }

    final theme = context.theme;
    final itemExtent = theme.spacing.s10 - theme.spacing.s1;
    final viewportHeight = theme.spacing.s12 * 4;
    final total = (widget.maxYear - widget.minYear) + 1;
    final selectedIndex = (widget.maxYear - widget.selectedYear).clamp(
      0,
      total - 1,
    );

    final target =
        (selectedIndex * itemExtent) - ((viewportHeight - itemExtent) / 2);
    final offset = target.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final itemExtent = theme.spacing.s10 - theme.spacing.s1;
    final height = theme.spacing.s12 * 4;
    final count = (widget.maxYear - widget.minYear) + 1;

    return SizedBox(
      height: height,
      child: ListView.builder(
        controller: _scrollController,
        primary: false,
        padding: EdgeInsets.zero,
        itemCount: count,
        itemExtent: itemExtent,
        itemBuilder: (context, index) {
          final year = widget.maxYear - index;
          return _YearItem(
            year: year,
            selected: year == widget.selectedYear,
            itemHeight: itemExtent,
            onTap: () => widget.onSelectYear(year),
          );
        },
      ),
    );
  }
}

class _YearItem extends StatefulWidget {
  const _YearItem({
    required this.year,
    required this.selected,
    required this.itemHeight,
    required this.onTap,
  });

  final int year;
  final bool selected;
  final double itemHeight;
  final VoidCallback onTap;

  @override
  State<_YearItem> createState() => _YearItemState();
}

class _YearItemState extends State<_YearItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bg = widget.selected || _hovered
        ? theme.colors.accent
        : theme.colors.card;

    return Semantics(
      label: '${widget.year}',
      button: true,
      selected: widget.selected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: theme.motion.fast,
            curve: theme.motion.curve,
            height: widget.itemHeight,
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.s3),
            color: bg,
            alignment: Alignment.centerLeft,
            child: Text(
              '${widget.year}',
              style: theme.typography.body.copyWith(
                color: theme.colors.cardForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
