import 'package:flutter/material.dart';
//TODO: Congratulations animation
//TODO: Disable tapping when puzzle is solved
//TODO: Responsive in every device

class GameHomeView extends StatefulWidget {
  final int tilesCount;

  const GameHomeView({Key? key, required this.tilesCount}) : super(key: key);

  @override
  _GameHomeViewState createState() => _GameHomeViewState();
}

class _GameHomeViewState extends State<GameHomeView> {
  bool _init = true;
  late List<int?> _tiles;
  final List<int?> _solvedPuzzle = [];
  late int _maxLengthOfPuzzle;

  @override
  void didChangeDependencies() {
    if(_init){
      _maxLengthOfPuzzle = widget.tilesCount*widget.tilesCount;
      _tiles = List<int?>.generate(_maxLengthOfPuzzle, (index) {
        if(index<_maxLengthOfPuzzle-1){
          return index+1;
        }else{
          return null;
        }
      });
      _solvedPuzzle.addAll(_tiles);
      _tiles.shuffle();
      if(mounted){
        setState(() {
          _init = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          // height: 100,
          height: _deviceHeight,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(flex: 6, child: Center(
                child: SizedBox(
                  width: 450,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _tiles.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.tilesCount,
                    ),
                    itemBuilder: (context, int i) {
                      int? _currentTile = _tiles[i];
                      if (_currentTile==null) {
                        return const SizedBox();
                      } else {
                        return InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: (){
                            if(_checkIfThisTileCanReplaceEmptySpace(i)){
                              onTilePositionChange(_currentTile, i);
                            }
                          },
                          child: Card(
                            color: Colors.amber,
                            child: Center(
                              child: FittedBox(child: Text("$_currentTile", style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),)),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),),
              const Expanded(child: SizedBox()),
            ],
          )
        ),
      ),
    );
  }

  bool _checkIfThisTileCanReplaceEmptySpace(int i) {
    int _currentNullIndex = _tiles.indexOf(null);
    if(_currentNullIndex-1==i){
      return true;
    }else if(_currentNullIndex-widget.tilesCount==i){
      return true;
    }else if(_currentNullIndex+widget.tilesCount==i){
      return true;
    }else if(((_currentNullIndex+1)%widget.tilesCount!=0)&&_currentNullIndex+1==i){
      return true;
    }else{
      return false;
    }
  }

  onTilePositionChange(int currentTile, int tappedIndex){
    int _currentNullIndex = _tiles.indexOf(null);
    _tiles[tappedIndex]=null;
    _tiles[_currentNullIndex] = currentTile;

    bool _isLastTileNull = _tiles.indexOf(null)==_maxLengthOfPuzzle-1;
    if(_isLastTileNull && isPuzzleSolved()){
      showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          title: const Text("Congratulations!!!"),
          content: const Text("You have solved the puzzle. Thank you for trying my game."),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
              _init = true;
              didChangeDependencies();
            }, child: const Text("Play again"))
          ],
        ),
      );
    }
    setState(() {});
  }

  bool isPuzzleSolved(){
    for(int i = 0; i<_maxLengthOfPuzzle; i++){
      if(_solvedPuzzle[i]!=_tiles[i]){
        return false;
      }
    }
    return true;
  }

}
