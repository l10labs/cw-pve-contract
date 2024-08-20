use dojo_starter::models::Letter;

// define the interface
#[dojo::interface]
trait IActions {
    fn spawn(ref world: IWorldDispatcher);
    // fn move(ref world: IWorldDispatcher, direction: Direction);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use super::{IActions};
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

    }
}