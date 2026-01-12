#!/bin/bash
# test-install.sh - Test suite for PIV installer
# Tests installation on various project fixtures

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIXTURES_DIR="$SCRIPT_DIR/fixtures"
PIV_SKELETON_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

# Source core functions
source "$PIV_SKELETON_DIR/scripts/install/core.sh"
source "$PIV_SKELETON_DIR/scripts/install/detect-tech.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test result tracking
test_result() {
    local name="$1"
    local result="$2"  # "pass" or "fail"
    local message="${3:-}"

    ((TESTS_RUN++))

    if [ "$result" = "pass" ]; then
        print_success "✓ $name"
        ((TESTS_PASSED++))
    else
        print_error "✗ $name"
        if [ -n "$message" ]; then
            echo "  → $message"
        fi
        ((TESTS_FAILED++))
    fi
}

# Test: Technology detection for Spring Boot
test_spring_boot_detection() {
    local test_dir="$FIXTURES_DIR/spring-boot-project"
    cd "$test_dir"

    # Clear detected technologies
    DETECTED_BACKENDS=()
    DETECTED_FRONTENDS=()
    DETECTED_DATABASES=()
    DETECTED_DEVOPS=()

    # Run detection
    detect_technologies > /dev/null 2>&1

    # Check results
    if [[ " ${DETECTED_BACKENDS[@]} " =~ " spring-boot " ]]; then
        test_result "Spring Boot detection" "pass"
    else
        test_result "Spring Boot detection" "fail" "Spring Boot not detected in ${DETECTED_BACKENDS[*]}"
    fi

    if [[ " ${DETECTED_DATABASES[@]} " =~ " postgresql " ]]; then
        test_result "PostgreSQL detection (Spring Boot)" "pass"
    else
        test_result "PostgreSQL detection (Spring Boot)" "fail" "PostgreSQL not detected"
    fi
}

# Test: Technology detection for Node.js
test_nodejs_detection() {
    local test_dir="$FIXTURES_DIR/nodejs-project"
    cd "$test_dir"

    DETECTED_BACKENDS=()
    DETECTED_FRONTENDS=()
    DETECTED_DATABASES=()
    DETECTED_DEVOPS=()

    detect_technologies > /dev/null 2>&1

    if [[ " ${DETECTED_BACKENDS[@]} " =~ " nodejs " ]]; then
        test_result "Node.js detection" "pass"
    else
        test_result "Node.js detection" "fail" "Node.js not detected"
    fi
}

# Test: Technology detection for React
test_react_detection() {
    local test_dir="$FIXTURES_DIR/react-project"
    cd "$test_dir"

    DETECTED_BACKENDS=()
    DETECTED_FRONTENDS=()
    DETECTED_DATABASES=()
    DETECTED_DEVOPS=()

    detect_technologies > /dev/null 2>&1

    if [[ " ${DETECTED_FRONTENDS[@]} " =~ " react " ]]; then
        test_result "React detection" "pass"
    else
        test_result "React detection" "fail" "React not detected"
    fi
}

# Test: Core functions
test_core_functions() {
    # Test print functions don't crash
    print_success "Test success message" > /dev/null
    test_result "print_success function" "pass"

    print_error "Test error message" > /dev/null
    test_result "print_error function" "pass"

    print_info "Test info message" > /dev/null
    test_result "print_info function" "pass"

    print_warning "Test warning message" > /dev/null
    test_result "print_warning function" "pass"

    # Test directory creation
    local test_tmpdir=$(mktemp -d)
    cd "$test_tmpdir"

    ensure_dir "test_dir"
    if [ -d "test_dir" ]; then
        test_result "ensure_dir function" "pass"
    else
        test_result "ensure_dir function" "fail" "Directory not created"
    fi

    rm -rf "$test_tmpdir"
}

# Test: File operations
test_file_operations() {
    local test_tmpdir=$(mktemp -d)
    cd "$test_tmpdir"

    # Test copy_file
    echo "test content" > source_file.txt
    copy_file "source_file.txt" "dest_file.txt"

    if [ -f "dest_file.txt" ] && [ "$(cat dest_file.txt)" = "test content" ]; then
        test_result "copy_file function" "pass"
    else
        test_result "copy_file function" "fail" "File not copied correctly"
    fi

    # Test copy_file_if_missing
    copy_file_if_missing "source_file.txt" "dest_file.txt"
    if [ -f "dest_file.txt" ]; then
        test_result "copy_file_if_missing (skip existing)" "pass"
    else
        test_result "copy_file_if_missing (skip existing)" "fail" "File was overwritten"
    fi

    rm -rf "$test_tmpdir"
}

# Main test runner
main() {
    print_header "PIV Installer Test Suite"

    # Save current directory
    local original_dir="$(pwd)"

    # Run tests
    test_core_functions
    test_file_operations
    test_spring_boot_detection
    test_nodejs_detection
    test_react_detection

    # Restore directory
    cd "$original_dir"

    # Print summary
    echo ""
    echo "$(printf '═%.0s' $(seq 1 60))"
    print_info "Test Summary"
    echo "$(printf '═%.0s' $(seq 1 60))"
    echo ""
    echo "Total:  $TESTS_RUN"
    print_success "Passed: $TESTS_PASSED"

    if [ $TESTS_FAILED -gt 0 ]; then
        print_error "Failed: $TESTS_FAILED"
        echo ""
        return 1
    else
        echo ""
        print_success "All tests passed!"
        echo ""
        return 0
    fi
}

# Run tests
main "$@"
