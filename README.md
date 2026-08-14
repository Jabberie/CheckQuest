# CheckQuest

A tiny World of Warcraft Retail addon for checking whether a quest has been completed on your current character.

## Usage

```text
/cq 12345
/checkquest 12345
```

Check several quests at once:

```text
/cq 12345 23456 34567
```

CheckQuest extracts quest IDs from pasted text as well, so a Wowhead quest URL can be pasted directly into the command.

### Commands

- `/cq <questID>` — check a quest.
- `/cq <questID> <questID> ...` — check multiple quests.
- `/cq help` — show command help.
- `/cq version` — show the installed addon version.
- `/rl` — reload the UI.
- `/fs` — toggle Blizzard's frame stack tool.

## Output

CheckQuest prints the quest name and ID when quest data is available, followed by a clear **Completed** or **Incomplete** result for the current character.

If the quest is not already cached by the client, CheckQuest requests its data and prints the result as soon as it becomes available.

## Compatibility

- World of Warcraft Retail
- Patch 12.1
- Interface 120100

## CurseForge

CheckQuest is available on CurseForge under the CheckQuest project.
