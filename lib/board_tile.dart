import 'package:flutter/material.dart';

import 'tile_state.dart';

class BoardTile extends StatelessWidget {
  final double dimension;
  final VoidCallback onPressed;
  final TileState tileState;
  const BoardTile({
    Key? key,
    required this.dimension,
    required this.onPressed,
    required this.tileState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      child: TextButton(
        child: _widgetForTileState(),
        onPressed: onPressed,
      ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget;

    switch (tileState) {
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;
      case TileState.CROSS:
        {
          widget = Image.asset('assets/images/x.png');
        }
        break;
      case TileState.CIRCLE:
        {
          widget = Image.asset('assets/images/o.png');
        }
        break;
    }
    return widget;
  }
}
