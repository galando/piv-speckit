#!/bin/bash
# test-unified.sh - Test suite for unified piv.sh

# Determine script directory (relative to this test file)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PIV_SCRIPT="$SCRIPT_DIR/scripts/piv.sh"

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Test helpers
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Assertion failed}"

    if [ "$expected" = "$actual" ]; then
        ((TESTS_PASSED++))
        return 0
    else
        echo "  ✗ $message"
        echo "    Expected: $expected"
        echo "    Got: $actual"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    if [ -f "$file" ]; then
        ((TESTS_PASSED++))
        return 0
    else
        echo "  ✗ File does not exist: $file"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_file_not_exists() {
    local file="$1"
    if [ ! -f "$file" ]; then
        ((TESTS_PASSED++))
        return 0
    else
        echo "  ✗ File exists (should not): $file"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Tests
test_fresh_install() {
    echo "TEST: Fresh install"

    local test_dir="/tmp/test-piv-fresh-$$"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # Run install
    bash "$PIV_SCRIPT" --force > /dev/null 2>&1

    # Verify
    assert_file_exists ".claude/reference/methodology/PIV-METHODOLOGY.md"
    assert_file_exists ".claude/.piv-version"
    assert_file_exists ".claude/commands/piv_loop/prime.md"

    # Cleanup
    cd /
    rm -rf "$test_dir"
}

test_update_existing() {
    echo "TEST: Update existing installation"

    local test_dir="/tmp/test-piv-update-$$"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # Initial install
    bash "$PIV_SCRIPT" --force > /dev/null 2>&1

    # Modify a file to simulate change
    echo "# modified" > .claude/commands/piv_loop/prime.md

    # Run update (should restore framework file)
    bash "$PIV_SCRIPT" --force > /dev/null 2>&1

    # Verify
    assert_file_exists ".claude/.piv-version"
    # File should be restored (not modified)

    # Cleanup
    cd /
    rm -rf "$test_dir"
}

test_migrate_legacy() {
    echo "TEST: Migrate legacy installation"

    local test_dir="/tmp/test-piv-migrate-$$"
    mkdir -p "$test_dir/.claude"
    cd "$test_dir"

    # Create old structure
    echo "# old methodology" > .claude/PIV-METHODOLOGY.md
    echo "VERSION=1.0.0" > .claude/.piv-version

    # Run update
    bash "$PIV_SCRIPT" --force > /dev/null 2>&1

    # Verify migration
    assert_file_exists ".claude/reference/methodology/PIV-METHODOLOGY.md"
    assert_file_not_exists ".claude/PIV-METHODOLOGY.md"

    # Cleanup
    cd /
    rm -rf "$test_dir"
}

test_version_file() {
    echo "TEST: Version file"

    local test_dir="/tmp/test-piv-version-$$"
    mkdir -p "$test_dir"
    cd "$test_dir"

    bash "$PIV_SCRIPT" --force > /dev/null 2>&1

    # Check version file format
    if grep -q "VERSION=" .claude/.piv-version; then
        ((TESTS_PASSED++))
    else
        echo "  ✗ VERSION= not found in .piv-version"
        ((TESTS_FAILED++))
    fi

    # Cleanup
    cd /
    rm -rf "$test_dir"
}

test_user_files_preserved() {
    echo "TEST: User files preserved"

    local test_dir="/tmp/test-piv-preserve-$$"
    mkdir -p "$test_dir/.claude/agents/learning"
    cd "$test_dir"

    # Create user files
    echo "my custom CLAUDE.md" > .claude/CLAUDE.md
    echo "my learning data" > .claude/agents/learning/metrics.md

    bash "$PIV_SCRIPT" --force > /dev/null 2>&1

    # Verify preserved
    if grep -q "my custom CLAUDE.md" .claude/CLAUDE.md; then
        ((TESTS_PASSED++))
    else
        echo "  ✗ CLAUDE.md was modified"
        ((TESTS_FAILED++))
    fi

    if grep -q "my learning data" .claude/agents/learning/metrics.md; then
        ((TESTS_PASSED++))
    else
        echo "  ✗ learning data was modified"
        ((TESTS_FAILED++))
    fi

    # Cleanup
    cd /
    rm -rf "$test_dir"
}

# Run all tests
main() {
    echo "====================================="
    echo "PIV Unified Script Test Suite"
    echo "====================================="
    echo ""

    test_fresh_install
    test_update_existing
    test_migrate_legacy
    test_version_file
    test_user_files_preserved

    echo ""
    echo "====================================="
    echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed"
    echo "====================================="

    if [ $TESTS_FAILED -gt 0 ]; then
        exit 1
    fi
}

main "$@"
