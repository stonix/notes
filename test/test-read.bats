#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "notes read: Should show created note" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"
  run $notes read note.md

  assert_success
  assert_output $'line1\nline2'
}

@test "notes read: Should show created note when using the cat shorthand alias" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"
  run $notes c note.md

  assert_success
  assert_output $'line1\nline2'
}

@test "notes read: Accepts names without .md to show" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"
  run $notes read note

  assert_success
  assert_output $'line1\nline2'
}

@test "notes read: Should fail to show non-existent note" {
  run $notes read note

  assert_failure
}

@test "notes read: Accepts relative notes paths to show" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"
  run $notes read $NOTES_DIRECTORY/note.md

  assert_success
  assert_output $'line1\nline2'
}

@test "notes read: Show a file passed by pipe from find" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"

  run bash -c "$notes find | $notes read"

  assert_success
  assert_output $'line1\nline2'
}

@test "notes read: Show multiple files passed by pipe from find" {
  echo line1 >> "$NOTES_DIRECTORY/note1.md"
  echo line2 >> "$NOTES_DIRECTORY/note2.md"

  run bash -c "$notes find | $notes read"

  assert_success
  assert_output $'line1\nline2'
}

@test "notes read: Should complain and ask for a name if one is not provided to show" {
  run $notes read

  assert_failure
  assert_line "Cat requires a name, but none was provided."
}
