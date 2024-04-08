import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';

enum Item {
  wood,
  apple,
  corn,
  tomato,
}

class PlayerInventoryManager extends Component with HasGameRef<DewValley> {
  PlayerInventoryManager();

  Map<Item, int> itemInventory = <Item, int>{
    Item.wood: 0,
    Item.apple: 0,
    Item.corn: 0,
    Item.tomato: 0,
  };

  void addItem(Item item, int amount) {
    itemInventory[item] = itemInventory[item]! + amount;
    print(itemInventory);
  }
}
