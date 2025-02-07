// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract PokemonFactory is Ownable {

    event NewPokemon(uint256 indexed _id, string _nickname, uint32 _personalityValue);
    
    mapping (uint256 => address) internal s_pokemonToOwner;
    mapping (address => uint256) internal s_ownerPokemonCount; // May not be more than 6
    mapping (uint8 => uint8[5]) internal s_nature_multipliers;
    uint256 internal s_pokemonCounter;
    Pokemon[] internal s_pokemons;

    error PokemonLimitExceeded(address trainerAddress);
    error PokemonOnlyOwnerAllowed(address trainerAddress, uint256 pokemonId);

    constructor() Ownable(_msgSender()) {
        s_pokemonCounter = 0;
        // 9 for 0.9 (decreased stat), 10 for (not increased nor decreased stat), 11 for (increased stat)
        s_nature_multipliers[1] = [10,10,10,10,10]; // Hardy
        s_nature_multipliers[2] = [9,11,10,10,10]; // Bold
        s_nature_multipliers[3] = [9,10,11,10,10]; // Modest
        s_nature_multipliers[4] = [9,10,10,11,10]; // Calm
        s_nature_multipliers[5] = [9,10,10,10,11]; // Timid
        s_nature_multipliers[6] = [11,9,10,10,10]; // Lonely
        s_nature_multipliers[7] = [10,10,10,10,10]; // Docile
        s_nature_multipliers[8] = [10,9,11,10,10]; // Mild
        s_nature_multipliers[9] = [10,9,10,11,10]; // Gentle
        s_nature_multipliers[10] = [10,9,10,10,11]; // Hasty
        s_nature_multipliers[11] = [11,10,9,10,10]; // Adamant
        s_nature_multipliers[12] = [10,11,9,10,10]; // Impish
        s_nature_multipliers[13] = [10,10,10,10,10]; // Bashful
        s_nature_multipliers[14] = [10,10,9,11,10]; // Careful
        s_nature_multipliers[15] = [10,10,11,9,10]; // Rash
        s_nature_multipliers[16] = [10,10,9,10,11]; // Jolly
        s_nature_multipliers[17] = [11,10,10,9,10]; // Naughty
        s_nature_multipliers[18] = [10,11,10,9,10]; // Lax
        s_nature_multipliers[19] = [10,10,10,10,10]; // Quirky
        s_nature_multipliers[20] = [10,10,10,9,11]; // Naive
        s_nature_multipliers[21] = [11,10,10,10,9]; // Brave
        s_nature_multipliers[22] = [10,11,10,10,9]; // Relaxed
        s_nature_multipliers[23] = [10,10,11,10,9]; // Quiet
        s_nature_multipliers[24] = [10,10,10,11,9]; // Sassy
        s_nature_multipliers[25] = [10,10,10,10,10]; // Serious
    }
    /**
     * Since data is saved in a struct, it is convenient to group the data of the same type together.
     * This way, the blockchain may store the data more efficiently. Less storage slots may be used.
     */
    struct Pokemon {
        uint256 id; // the token id    
        string nickname;
        string img_sprite_url; // just the img url
        string ability1_name;
        string ability2_name;
        
        uint16 pokedex_id;
        uint16 base_hp;
        uint16 base_attack;
        uint16 base_defense;
        uint16 base_attack_sp;
        uint16 base_defense_sp;
        uint16 base_speed;

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

    modifier isPokemonTrainer(uint256 _pokemonId) {
        if (s_pokemonToOwner[_pokemonId] != _msgSender()) {
            revert PokemonOnlyOwnerAllowed(s_pokemonToOwner[_pokemonId], _pokemonId);
        }
        _;
    }

    function createRandomPokemon(
        uint16 _pokedex_id,
        string memory _nickname,
        string memory _img_sprite_url,
        string memory _ability1_name,
        string memory _ability2_name,
        uint16 _base_hp,
        uint16 _base_attack,
        uint16 _base_defense,
        uint16 _base_attack_sp,
        uint16 _base_defense_sp,
        uint16 _base_speed,
        uint16 _base_height,
        uint16 _base_weight
    ) public returns (uint256) {

        if (s_ownerPokemonCount[_msgSender()] >= 6) { // A trainer cannot carry more than 6 pokemons
            revert PokemonLimitExceeded(_msgSender());
        }

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
        uint8 nature = _getNatureFromEncryptionConstant(encryption_constant); // Value from 1 to 25
        // Calculate the ability
        bool hasSecondAbility = _hasSecondAbility(personality_value);
        if (!hasSecondAbility) {
            _ability2_name = "";
        }

        // Initializing empty values
        uint32 exp = 0;
        uint8 level = 1;
        bool isShiny = false;
        string[4] memory moves = ["","","",""];
        address held_item = address(0);

        Pokemon memory newPokemon = Pokemon(
            s_pokemonCounter++, // provide token id and then increase the counter
            _nickname,
            _img_sprite_url,
            _ability1_name,
            _ability2_name,
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

        return newPokemon.id;
    }

    function releasePokemon(uint256 _pokemonId) public isPokemonTrainer(_pokemonId) {
        s_ownerPokemonCount[_msgSender()]--;
        delete s_pokemonToOwner[_pokemonId];
        delete s_pokemons[_pokemonId];
    }

    function _createPokemon(Pokemon memory _pokemon) private {
        s_pokemons.push(_pokemon);
        s_pokemonToOwner[_pokemon.id] = _msgSender();
        s_ownerPokemonCount[_msgSender()]++;
        emit NewPokemon(_pokemon.id, _pokemon.nickname, _pokemon.personality_value); // array_id = pokemons.length - 1
    }

    function _getRandomPersonalityValue() private view returns (uint32) {
        // Maybe we can user a VRF Coordinator in the future to get
        // the Linear Congruential random number like bulbapedia says
        uint256 personalityValueNotModuled = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, s_pokemons.length)));
        return uint32(personalityValueNotModuled);
    }

    function _getRandomEncryptionConstant() private view returns (uint32) {
        uint256 encryptionCtNotModuled = uint256(sha256(abi.encodePacked(block.prevrandao, block.timestamp, s_pokemons.length)));
        return uint32(encryptionCtNotModuled);
    }

    function _getRandomIVValue(string memory _iv_type) private view returns (uint8) {
        uint256 ivNotModuled = uint256(keccak256(abi.encodePacked(_iv_type, block.prevrandao, block.timestamp, s_pokemons.length)));
        return uint8(ivNotModuled % 32);
    }

    function _getRandomEVValue(string memory _ev_type) private view returns (uint8) {
        uint256 evNotModuled = uint256(keccak256(abi.encodePacked(_ev_type, block.prevrandao, block.timestamp, s_pokemons.length)));
        return uint8(evNotModuled % 256);
    }

    function _getNatureFromEncryptionConstant(uint32 _encryption_constant) private pure returns (uint8) {
        return uint8(_encryption_constant % 25) + 1;
    }

    function _hasSecondAbility(uint32 _personality_value) private pure returns (bool) {
        return _personality_value % 2 == 1;
    }
    
}
