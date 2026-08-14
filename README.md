# CheckQuest

A lightweight World of Warcraft Retail addon for checking whether quests have been completed on the current character.

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

CheckQuest accepts up to **50 unique quest IDs per command**. Duplicate IDs are ignored.

Quest IDs can also be extracted from pasted text, including Wowhead quest URLs.

## Commands

- `/cq <questID>` — check one quest.
- `/cq <questID> <questID> ...` — check multiple quests, up to 50 unique IDs.
- `/checkquest ...` — long-form alias for `/cq`.
- `/cq help` — show command help.
- `/cq version` — show the installed addon version.
- `/rl` — reload the UI.
- `/fs` — toggle the Blizzard Frame Stack tool.

## Output

CheckQuest prints the quest name and ID when quest data is available, followed by a clear **Completed** or **Incomplete** result.

If quest data is not already cached by the client, CheckQuest requests it and prints the result when the data becomes available.

## Compatibility

- World of Warcraft Retail
- Patch 12.1
- Interface 120100

## Releases

Release builds are created automatically from Git tags ending in `_release`.

For example:

```text
1.2.0_release
```

The packaged addon version is derived from the tag, with `_release` removed.

## CurseForge

CheckQuest is available on CurseForge under the CheckQuest project.
