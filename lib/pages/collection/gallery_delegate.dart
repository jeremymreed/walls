import 'package:flutter/rendering.dart';

// rawDimension is the desired width/height for each card.
// fixedDimension is the final width/height for each card after calculating the
// number of cards that can fit in each row.
class CustomGridDelegate extends SliverGridDelegate {
  CustomGridDelegate({required this.rawDimension});

  // This is the desired height of each row (and width of each square).
  // When there is not enough room, we shrink this to the width of the scroll view.
  final double rawDimension;

  // The layout is two rows of squares, then one very wide cell, repeat.

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // Determine how many squares we can fit per row.
    // This is a truncating division operation, some fractional part may be dropped.
    int count = constraints.crossAxisExtent ~/ rawDimension;
    if (count < 1) {
      count = 1; // Always fit at least one regardless.
    }

    // This is the width of each card, factoring in the rounding.
    // This isn't always equal to dimension.  Refers to the same length.
    final double fixedDimension = constraints.crossAxisExtent / count;
    return CustomGridLayout(
      crossAxisCount: count,
      dimension: fixedDimension,
    );
  }

  @override
  bool shouldRelayout(CustomGridDelegate oldDelegate) {
    return rawDimension != oldDelegate.rawDimension;
  }
}

// loopLength is the number of cards in a row.
// loopHeight is the height of a row, which is the same as the width of a card.
class CustomGridLayout extends SliverGridLayout {
  const CustomGridLayout({
    required this.crossAxisCount,
    required this.dimension,
  })  : assert(crossAxisCount > 0),
        loopLength = crossAxisCount,
        loopHeight = dimension;

  final int crossAxisCount;
  final double dimension;

  // Computed values.
  final int loopLength;
  final double loopHeight;

  @override
  double computeMaxScrollOffset(int childCount) {
    // This returns the scroll offset of the end side of the childCount'th child.
    // In the case of this example, this method is not used, since the grid is
    // infinite. However, if one set an itemCount on the GridView above, this
    // function would be used to determine how far to allow the user to scroll.
    if (childCount == 0 || dimension == 0) {
      return 0;
    }

    // childCount ~/ loopLength tells us which row this child belongs to.
    // multiply by loopHeight to get the y offset of the row in pixels.
    // childCount % loopLength tells us which column this child belongs to.
    // divide by crossAxisCount to get the fractional x offset of the column.
    // Multiply by dimension to get the x offset of the column in pixels.
    return (childCount ~/ loopLength) * loopHeight +
        ((childCount % loopLength) ~/ crossAxisCount) * dimension;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // This returns the position of the index'th tile.
    //
    // The SliverGridGeometry object returned from this method has four
    // properties. For a grid that scrolls down, as in this example, the four
    // properties are equivalent to x,y,width,height. However, since the
    // GridView is direction agnostic, the names used for SliverGridGeometry are
    // also direction-agnostic.
    //
    // Try changing the scrollDirection and reverse properties on the GridView
    // to see how this algorithm works in any direction (and why, therefore, the
    // names are direction-agnostic).
    final int loop = index ~/ loopLength; // row index.
    final int loopIndex = index % loopLength; // column index.

    final int rowIndex = loopIndex ~/ crossAxisCount;
    final int columnIndex = loopIndex % crossAxisCount;
    return SliverGridGeometry(
      scrollOffset: (loop * loopHeight) + (rowIndex * dimension), // "y"
      crossAxisOffset: columnIndex * dimension, // "x"
      mainAxisExtent: dimension, // "height"
      crossAxisExtent: dimension, // "width"
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // This returns the first index that is visible for a given scrollOffset.
    //
    // The GridView only asks for the geometry of children that are visible
    // between the scroll offset passed to getMinChildIndexForScrollOffset and
    // the scroll offset passed to getMaxChildIndexForScrollOffset.
    //
    // It is the responsibility of the SliverGridLayout to ensure that
    // getGeometryForChildIndex is consistent with getMinChildIndexForScrollOffset
    // and getMaxChildIndexForScrollOffset.
    //
    // Not every child between the minimum child index and the maximum child
    // index need be visible (some may have scroll offsets that are outside the
    // view; this happens commonly when the grid view places tiles out of
    // order). However, doing this means the grid view is less efficient, as it
    // will do work for children that are not visible. It is preferred that the
    // children are returned in the order that they are laid out.
    final int rows =
        scrollOffset ~/ dimension; // The row number for this offset.
    return rows * crossAxisCount;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // (See commentary above.)
    final int rows = scrollOffset ~/ dimension;

    return (rows * crossAxisCount) + (crossAxisCount - 1);
  }
}
