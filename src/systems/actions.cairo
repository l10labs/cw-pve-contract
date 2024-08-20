use dojo_starter::models::Letter;
use starknet::{ContractAddress};
const NUM_LETTERS: u32 = 5;

const THE_ULTIMATE_WORDLE_LIST: [felt252; 15 ] = [
  'apple', 'abide', 'angel', 'amaze', 'arise',
  'brave', 'blaze', 'beach', 'bacon', 'badge',
  'crane', 'charm', 'clean', 'candy', 'cabin',
];


// define the interface
#[dojo::interface]
trait IActions {
    fn spawn(ref world: IWorldDispatcher);
    fn generate_wordle(ref world: IWorldDispatcher);
    // fn generate_wordle(ref world: IWorldDispatcher, word: [felt252; NUM_LETTERS], player: ContractAddress);

}

// dojo decorator
#[dojo::contract]
mod actions {
    use super::{IActions, NUM_LETTERS, THE_ULTIMATE_WORDLE_LIST};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::Letter;

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
      fn spawn(ref world: IWorldDispatcher) {

            let player = get_caller_address();
            let position = 4;
            let letter = Letter {player, position, value: 0};

            set!(world, (letter));
      }

      fn generate_wordle(ref world: IWorldDispatcher) {
          let word_list = THE_ULTIMATE_WORDLE_LIST.span();
          let y: u256 = (*word_list[0]).into();
          let letter = u256_word_to_letters(y);
      }
    }
    
    fn u256_word_to_letters(word: u256) -> [u8; NUM_LETTERS] {
      let letter_1: u8 = ((word & 0xff00000000.into()) / 0x0100000000.into()).try_into().unwrap();
      let letter_2: u8 = ((word & 0x00ff000000.into()) / 0x0001000000.into()).try_into().unwrap();
      let letter_3: u8 = ((word & 0x0000ff0000.into()) / 0x0000010000.into()).try_into().unwrap();
      let letter_4: u8 = ((word & 0x000000ff00.into()) / 0x0000000100.into()).try_into().unwrap();
      let letter_5: u8 = ((word & 0x00000000ff.into()) / 0x0000000001.into()).try_into().unwrap();
      println!("{}, {}, {}, {}, {}", letter_1, letter_2, letter_3, letter_4, letter_5);
      [letter_1, letter_2, letter_3, letter_4, letter_5]
    }
}