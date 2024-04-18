import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';
import 'package:dew_valley/src/models/Item.dart';

class PlayerInventoryManager extends Component with HasGameRef<DewValley> {
  PlayerInventoryManager();

  Map<Item, int> itemInventory = <Item, int>{
    Item.wood: 0,
    Item.apple: 0,
    Item.corn: 5,
    Item.tomato: 5,
  };

  void addItem(Item item, int amount) {
    itemInventory[item] = itemInventory[item]! + amount;
    print(itemInventory);
  }

  bool useItem(Item item) {
    if (itemInventory[item]! == 0) {
      return false;
    }

    itemInventory[item] = itemInventory[item]! - 1;
    return true;
  }
}
