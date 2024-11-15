// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract PokemonFactory {

    event NewPokemon(uint256 id, string nickname, uint32 personalityValue);

    /**
     * Since data is saved in a struct, it is convenient to group the data of the same type together.
     * This way, the blockchain may store the data more efficiently. Less storage slots may be used.
     */
    struct Pokemon {

        string nickname;
        string img_sprite_name;
        string ability1_name;
        string ability2_name;
        
        uint16 pokedex_id;
        uint16 hp;
        uint16 attack;
        uint16 defense;
        uint16 attack_sp;
        uint16 defense_sp;
        uint16 speed;

        uint16 height;
        uint16 weight;

        uint32 exp; // It does not go up 1_640_000
        uint32 personality_value;
        uint32 encryption_constant;

        //string type1; Can be retrieved from the pokedex
        //string type2; Can be retrieved from the pokedex

        uint8 iv_hp; // Ranges from 0 to 31
        uint8 iv_attack;
        uint8 iv_defense;
        uint8 iv_attack_sp;
        uint8 iv_defense_sp;
        uint8 iv_speed;

        uint8 ev_hp; // Ranges from 0 to 255
        uint8 ev_attack;
        uint8 ev_defense;
        uint8 ev_attack_sp;
        uint8 ev_defense_sp;
        uint8 ev_speed;

        uint8 nature_index; // No need to store what the nature does, just the corresponding index in the list. Increased and decreased stats to be retrieved in the front end.
        uint8 level; // Ranges from 1 to 100

        //uint8 generation; // Can be retrieved from the pokedex
        bool is_shiny;
        
        string[4] moves;
        address held_item;
    }

    Pokemon[] public pokemons;

    mapping (uint256 => address) public pokemonToOwner;
    mapping (address => uint256) ownerPokemonCount; // May not be more than 6

    function createRandomPokemon(
        uint16 _pokedex_id,
        string memory _nickname,
        string memory img_sprite_name,
        string memory ability1_name,
        string memory ability2_name,
        uint16 _base_hp,
        uint16 _base_attack,
        uint16 _base_defense,
        uint16 _base_attack_sp,
        uint16 _base_defense_sp,
        uint16 _base_speed,
        uint16 _base_height,
        uint16 _base_weight
    ) public onlyOwner{

        require(ownerPokemonCount[msg.sender] < 6); // A trainer cannot carry more than 6 pokemons

         uint32 personality_value = _getRandomPersonalityValue(); // Value from 0 to 4_294_967_295

        uint32 encryption_constant = _getRandomEncryptionConstant();

        // Calculate the IVs
        uint8 iv_hp = _getRandomIVValue("hp");
        uint8 iv_atk = _getRandomIVValue("attack");
        uint8 iv_def = _getRandomIVValue("defense");
        uint8 iv_atk_sp = _getRandomIVValue("sp_attack");
        uint8 iv_def_sp = _getRandomIVValue("sp_defense");
        uint8 iv_speed = _getRandomIVValue("speed");
        // Calculate the EVs
        uint8 ev_hp = _getRandomEVValue("hp");
        uint8 ev_atk = _getRandomEVValue("attack");
        uint8 ev_def = _getRandomEVValue("defense");
        uint8 ev_atk_sp = _getRandomEVValue("sp_attack");
        uint8 ev_def_sp = _getRandomEVValue("sp_defense");
        uint8 ev_speed = _getRandomEVValue("speed");

        // We don't modify the _base_height-weight yet

        // Calculate the nature
        uint8 nature = _getNatureFromEncryptionConstant(encryption_constant); // Value from 0 to 24
        // Calculate the ability
        bool hasSecondAbility = _hasSecondAbility(personality_value);
        if (!hasSecondAbility) {
            ability2_name = "";
        }

        // Initializing empty values
        uint32 exp = 0;
        uint8 level = 1;
        bool isShiny = false;
        string[4] memory moves = ["","","",""];
        address held_item = address(0);

        Pokemon memory newPokemon = Pokemon(
            _nickname,
            img_sprite_name,
            ability1_name,
            ability2_name,
            _pokedex_id,
            _base_hp,
            _base_attack,
            _base_defense,
            _base_attack_sp,
            _base_defense_sp,
            _base_speed,
            _base_height,
            _base_weight,
            exp,
            personality_value,
            encryption_constant,
            iv_hp,
            iv_atk,
            iv_def,
            iv_atk_sp,
            iv_def_sp,
            iv_speed,
            ev_hp,
            ev_atk,
            ev_def,
            ev_atk_sp,
            ev_def_sp,
            ev_speed,
            nature,
            level,
            isShiny,
            moves, // Moves to be added later
            held_item
        );

        _createPokemon(newPokemon);
    }

    function _createPokemon(Pokemon memory pokemon) private {
        pokemons.push(pokemon);
        pokemonToOwner[pokemons.length - 1] = msg.sender;
        ownerPokemonCount[msg.sender]++;
        emit NewPokemon(pokemons.length - 1, pokemon.nickname, pokemon.personality_value); // array_id = pokemons.length - 1
    }

    function _getRandomPersonalityValue() private view returns (uint32) {
        // Maybe we can user a VRF Coordinator in the future to get
        // the Linear Congruential random number like bulbapedia says
        uint256 personalityValueNotModuled = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, pokemons.length)));
        return uint32(personalityValueNotModuled);
    }

    function _getRandomEncryptionConstant() private view returns (uint32) {
        uint256 encryptionCtNotModuled = uint256(sha256(abi.encodePacked(block.prevrandao, block.timestamp, pokemons.length)));
        return uint32(encryptionCtNotModuled);
    }

    function _getRandomIVValue(string memory iv_type) private view returns (uint8) {
        uint256 ivNotModuled = uint256(keccak256(abi.encodePacked(iv_type, block.prevrandao, block.timestamp, pokemons.length)));
        return uint8(ivNotModuled % 32);
    }

    function _getRandomEVValue(string memory ev_type) private view returns (uint8) {
        uint256 evNotModuled = uint256(keccak256(abi.encodePacked(ev_type, block.prevrandao, block.timestamp, pokemons.length)));
        return uint8(evNotModuled % 256);
    }

    function _getNatureFromEncryptionConstant(uint32 _encryption_constant) private pure returns (uint8) {
        return uint8(_encryption_constant % 25);
    }

    function _hasSecondAbility(uint32 _personality_value) private pure returns (bool) {
        return _personality_value % 2 == 1;
    }
    
}
