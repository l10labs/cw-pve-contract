#[cfg(test)]
mod tests {
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::utils::test::{spawn_test_world, deploy_contract};
    use dojo_starter::{
        // systems::create::{create_actions, ICreateDispatcher, ICreateDispatcherTrait},
        // models::board::{Letter, letter, LetterStatus, letter_status, Status},
        systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait},
        models::{Letter, letter, Wordle, wordle},
    };

    fn setup() -> (IWorldDispatcher, IActionsDispatcher) {
        // world setup
        let mut models = array![letter::TEST_CLASS_HASH];
        let world = spawn_test_world(["dojo_starter"].span(), models.span());
        let contract_address = world
            .deploy_contract(
                'salt', actions::TEST_CLASS_HASH.try_into().unwrap()
            );
        let systems = IActionsDispatcher { contract_address };

        world.grant_writer(dojo::utils::bytearray_hash(@"dojo_starter"), contract_address);

        (world, systems)
    }

    #[test]
    fn test_word_generation(){
        let caller = starknet::contract_address_const::<0x0>();
        let (world, systems) = setup();

        let mut index: u8 = 0;
        while index < 5 {
            let old_letters = get!(world, (caller, index), Letter);
            println!("old_letters {}: {:?}", index, old_letters);
            index += 1;
        };

        let letter = systems.generate_wordle();

        let mut index: u8 = 0;
        while index < 5 {
            let new_letters = get!(world, (caller, index), Letter);
            println!("new_letters {}: {:?}", index, new_letters);
            index += 1;
        };
        
        // let new_letters = get!(world, (caller, 1), Letter);
        // println!("new_letters: {:?}", new_letters);

    }
}
