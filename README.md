# CheckQuest

CheckQuest is a lightweight World of Warcraft addon for checking whether one or more quests have been completed on the current character.

## Supported clients

The same package supports:

- World of Warcraft Retail 12.1.0
- WoW Classic Era 1.15.9
- Burning Crusade Classic Anniversary 2.5.6
- Mists of Pandaria Classic 5.5.4

## Usage

Check one quest:

```text
/cq 12345
/checkquest 12345
```

Check several quests at once:

```text
/cq 12345 23456 34567
```

Up to 50 unique quest IDs can be checked with one command. Duplicate IDs are ignored.

Quest IDs can also be extracted from pasted text or URLs containing numeric quest IDs.

## Commands

```text
/cq help
/cq version
```

Convenience commands:

```text
/rl    Reload the UI
/fs    Toggle Blizzard's Frame Stack tool
```

## Results

CheckQuest prints each quest name, quest ID, and completion state directly to chat. If the quest name is not cached, the addon requests the quest data and prints the result when it becomes available.

## Installation

Extract the `CheckQuest` folder into your World of Warcraft `Interface/AddOns` directory for the client you use.

## Release versioning

CheckQuest uses expansion-based release numbers. During expansion 12, releases are numbered `12.001`, `12.002`, and so on.

## License

CheckQuest is released under the MIT License. See `LICENSE` for details.
