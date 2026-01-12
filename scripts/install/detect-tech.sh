#!/bin/bash
# detect-tech.sh - Technology detection for PIV installer
# Detects project technologies based on configuration files

# Source core functions if not already loaded
#if [ -z "${print_info+x}" ]; then
#    source "$(dirname "${BASH_SOURCE[0]}")/core.sh"
#fi

# Detected technologies (global array)
DETECTED_BACKENDS=()
DETECTED_FRONTENDS=()
DETECTED_DATABASES=()
DETECTED_DEVOPS=()

# Detection functions for backend technologies

detect_spring_boot() {
    log "INFO" "Checking for Spring Boot..."
    # Check for pom.xml (Maven)
    if find . -name "pom.xml" -type f 2>/dev/null | head -1 | grep -q .; then
        local pom_file=$(find . -name "pom.xml" -type f 2>/dev/null | head -1)
        log "INFO" "Found pom.xml at: $pom_file"
        if grep -qi "spring-boot" "$pom_file"; then
            log "INFO" "Detected Spring Boot via $pom_file"
            print_success "Spring Boot (backend) detected"
            return 0
        else
            log "INFO" "pom.xml found but no spring-boot dependency detected"
        fi
    else
        log "INFO" "No pom.xml found in current directory"
    fi
    # Check for build.gradle (Gradle)
    if find . \( -name "build.gradle" -o -name "build.gradle.kts" \) -type f 2>/dev/null | head -1 | grep -q .; then
        local gradle_file=$(find . \( -name "build.gradle" -o -name "build.gradle.kts" \) -type f 2>/dev/null | head -1)
        log "INFO" "Found gradle file at: $gradle_file"
        if grep -qi "spring-boot" "$gradle_file"; then
            log "INFO" "Detected Spring Boot via $gradle_file"
            print_success "Spring Boot (backend) detected"
            return 0
        else
            log "INFO" "gradle file found but no spring-boot dependency detected"
        fi
    else
        log "INFO" "No gradle file found in current directory"
    fi
    log "INFO" "Spring Boot not detected"
    return 1
}

detect_nodejs() {
    if [ -f "package.json" ]; then
        # Check if it's a backend project (not just frontend)
        if grep -qE '"(express|fastify|koa|nest|nestjs|hapi|loopback)"' package.json; then
            return 0
        fi
        # Default to treating node.js as backend if no frontend framework detected
        if ! grep -qiE "(react|vue|angular|svelte)" package.json; then
            return 0
        fi
    fi
    return 1
}

detect_python() {
    if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        # Check for backend frameworks
        if [ -f "requirements.txt" ] && grep -qiE "(fastapi|django|flask|tornado)" requirements.txt; then
            return 0
        fi
        if [ -f "pyproject.toml" ] && grep -qiE "(fastapi|django|flask|tornado)" pyproject.toml; then
            return 0
        fi
        return 0  # Assume Python is backend if present
    fi
    return 1
}

detect_go() {
    if [ -f "go.mod" ]; then
        return 0
    fi
    return 1
}

detect_rust() {
    if [ -f "Cargo.toml" ]; then
        return 0
    fi
    return 1
}

detect_ruby() {
    if [ -f "Gemfile" ]; then
        if grep -qi "(rails|sinatra|grape)" Gemfile; then
            return 0
        fi
    fi
    return 1
}

# Detection functions for frontend technologies

detect_react() {
    if [ -f "package.json" ]; then
        if grep -qiE '"react"' package.json; then
            return 0
        fi
    fi
    return 1
}

detect_vue() {
    if [ -f "package.json" ]; then
        if grep -qiE '"vue"' package.json; then
            return 0
        fi
    fi
    return 1
}

detect_angular() {
    if [ -f "package.json" ]; then
        if grep -qiE '"@angular"' package.json; then
            return 0
        fi
    fi
    return 1
}

detect_svelte() {
    if [ -f "package.json" ]; then
        if grep -qiE '"svelte"' package.json; then
            return 0
        fi
    fi
    return 1
}

detect_nextjs() {
    if [ -f "package.json" ]; then
        if grep -qiE '"next"' package.json; then
            return 0
        fi
    fi
    return 1
}

# Detection functions for databases

detect_postgres() {
    # Check dependency files
    if [ -f "package.json" ] && grep -qiE 'pg|postgres|postgresql' package.json; then
        return 0
    fi
    if [ -f "pom.xml" ] && grep -qiE 'postgresql' pom.xml; then
        return 0
    fi
    if [ -f "requirements.txt" ] && grep -qiE 'psycopg|postgres' requirements.txt; then
        return 0
    fi
    if [ -f "pyproject.toml" ] && grep -qiE 'psycopg|postgres' pyproject.toml; then
        return 0
    fi
    # Check for docker-compose with postgres
    if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
        if grep -qiE 'postgres|postgresql' docker-compose.y*ml 2>/dev/null; then
            return 0
        fi
    fi
    # Check for environment files
    if [ -f ".env" ] || [ -f ".env.example" ]; then
        if grep -qiE 'postgres|postgresql' .env* 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

detect_mysql() {
    if [ -f "package.json" ] && grep -qiE 'mysql|mariadb' package.json; then
        return 0
    fi
    if [ -f "pom.xml" ] && grep -qiE 'mysql|mariadb' pom.xml; then
        return 0
    fi
    if [ -f "requirements.txt" ] && grep -qiE 'pymysql|mysqlclient' requirements.txt; then
        return 0
    fi
    if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
        if grep -qiE 'mysql|mariadb' docker-compose.y*ml 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

detect_mongodb() {
    if [ -f "package.json" ] && grep -qiE 'mongodb|mongoose' package.json; then
        return 0
    fi
    if [ -f "pom.xml" ] && grep -qiE 'mongodb' pom.xml; then
        return 0
    fi
    if [ -f "requirements.txt" ] && grep -qiE 'pymongo|motor' requirements.txt; then
        return 0
    fi
    if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
        if grep -qiE 'mongodb' docker-compose.y*ml 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

detect_redis() {
    if [ -f "package.json" ] && grep -qiE 'redis' package.json; then
        return 0
    fi
    if [ -f "pom.xml" ] && grep -qiE 'redis|jedis' pom.xml; then
        return 0
    fi
    if [ -f "requirements.txt" ] && grep -qiE 'redis' requirements.txt; then
        return 0
    fi
    if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
        if grep -qiE 'redis' docker-compose.y*ml 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Detection functions for devops tools

detect_docker() {
    if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
        return 0
    fi
    return 1
}

detect_kubernetes() {
    if [ -d "k8s" ] || [ -d "kubernetes" ] || [ -d ".k8s" ]; then
        return 0
    fi
    if ls *.yaml 2>/dev/null | grep -qiE "deployment|service|ingress"; then
        return 0
    fi
    return 1
}

detect_terraform() {
    if [ -f "main.tf" ] || ls *.tf 2>/dev/null | head -1; then
        return 0
    fi
    return 1
}

# Main detection function
detect_technologies() {
    print_info "Scanning project for technologies..."

    # Detect backends
    if detect_spring_boot; then
        DETECTED_BACKENDS+=("spring-boot")
    fi
    if detect_nodejs; then
        DETECTED_BACKENDS+=("nodejs")
        print_success "Node.js (backend) detected"
    fi
    if detect_python; then
        DETECTED_BACKENDS+=("python")
        print_success "Python (backend) detected"
    fi
    if detect_go; then
        DETECTED_BACKENDS+=("go")
        print_success "Go (backend) detected"
    fi
    if detect_rust; then
        DETECTED_BACKENDS+=("rust")
        print_success "Rust (backend) detected"
    fi
    if detect_ruby; then
        DETECTED_BACKENDS+=("ruby")
        print_success "Ruby (backend) detected"
    fi

    # Detect frontends
    if detect_react; then
        DETECTED_FRONTENDS+=("react")
        print_success "React (frontend) detected"
    fi
    if detect_vue; then
        DETECTED_FRONTENDS+=("vue")
        print_success "Vue (frontend) detected"
    fi
    if detect_angular; then
        DETECTED_FRONTENDS+=("angular")
        print_success "Angular (frontend) detected"
    fi
    if detect_svelte; then
        DETECTED_FRONTENDS+=("svelte")
        print_success "Svelte (frontend) detected"
    fi
    if detect_nextjs; then
        DETECTED_FRONTENDS+=("nextjs")
        print_success "Next.js (frontend) detected"
    fi

    # Detect databases
    if detect_postgres; then
        DETECTED_DATABASES+=("postgresql")
        print_success "PostgreSQL detected"
    fi
    if detect_mysql; then
        DETECTED_DATABASES+=("mysql")
        print_success "MySQL/MariaDB detected"
    fi
    if detect_mongodb; then
        DETECTED_DATABASES+=("mongodb")
        print_success "MongoDB detected"
    fi
    if detect_redis; then
        DETECTED_DATABASES+=("redis")
        print_success "Redis detected"
    fi

    # Detect devops
    if detect_docker; then
        DETECTED_DEVOPS+=("docker")
        print_success "Docker detected"
    fi
    if detect_kubernetes; then
        DETECTED_DEVOPS+=("kubernetes")
        print_success "Kubernetes detected"
    fi
    if detect_terraform; then
        DETECTED_DEVOPS+=("terraform")
        print_success "Terraform detected"
    fi

    # If nothing detected, note it
    if [ ${#DETECTED_BACKENDS[@]} -eq 0 ] && \
       [ ${#DETECTED_FRONTENDS[@]} -eq 0 ] && \
       [ ${#DETECTED_DATABASES[@]} -eq 0 ] && \
       [ ${#DETECTED_DEVOPS[@]} -eq 0 ]; then
        print_warning "No specific technologies detected"
        return 1
    fi

    return 0
}

# Display detected technologies
display_detected() {
    echo ""
    print_header "Detected Technologies"

    if [ ${#DETECTED_BACKENDS[@]} -gt 0 ]; then
        echo "Backend:"
        for tech in "${DETECTED_BACKENDS[@]}"; do
            echo "  ✓ $tech"
        done
    fi

    if [ ${#DETECTED_FRONTENDS[@]} -gt 0 ]; then
        echo ""
        echo "Frontend:"
        for tech in "${DETECTED_FRONTENDS[@]}"; do
            echo "  ✓ $tech"
        done
    fi

    if [ ${#DETECTED_DATABASES[@]} -gt 0 ]; then
        echo ""
        echo "Database:"
        for tech in "${DETECTED_DATABASES[@]}"; do
            echo "  ✓ $tech"
        done
    fi

    if [ ${#DETECTED_DEVOPS[@]} -gt 0 ]; then
        echo ""
        echo "DevOps:"
        for tech in "${DETECTED_DEVOPS[@]}"; do
            echo "  ✓ $tech"
        done
    fi
    echo ""
}

# Confirm or modify detected technologies
confirm_technologies() {
    display_detected

    if confirm "Is this correct?"; then
        return 0
    fi

    # Manual selection
    print_info "Let's select technologies manually"
    echo ""

    # Select backend
    select_menu "Select backend technology:" \
        "Spring Boot (Java/Kotlin)" \
        "Node.js/Express" \
        "Python/FastAPI" \
        "None/Skip"

    case $? in
        1) DETECTED_BACKENDS=("spring-boot") ;;
        2) DETECTED_BACKENDS=("nodejs") ;;
        3) DETECTED_BACKENDS=("python") ;;
        4) DETECTED_BACKENDS=() ;;
    esac

    # Select frontend
    select_menu "Select frontend technology:" \
        "React" \
        "Vue.js" \
        "Angular" \
        "Svelte" \
        "None/Skip"

    case $? in
        1) DETECTED_FRONTENDS=("react") ;;
        2) DETECTED_FRONTENDS=("vue") ;;
        3) DETECTED_FRONTENDS=("angular") ;;
        4) DETECTED_FRONTENDS=("svelte") ;;
        5) DETECTED_FRONTENDS=() ;;
    esac

    # Select database
    select_menu "Select database:" \
        "PostgreSQL" \
        "MySQL/MariaDB" \
        "MongoDB" \
        "Redis" \
        "None/Skip"

    case $? in
        1) DETECTED_DATABASES=("postgresql") ;;
        2) DETECTED_DATABASES=("mysql") ;;
        3) DETECTED_DATABASES=("mongodb") ;;
        4) DETECTED_DATABASES=("redis") ;;
        5) DETECTED_DATABASES=() ;;
    esac

    # Select devops
    if confirm "Do you use Docker?"; then
        DETECTED_DEVOPS=("docker")
    else
        DETECTED_DEVOPS=()
    fi

    echo ""
    print_success "Technologies updated"
    return 0
}

# Get list of all detected technologies as comma-separated string
get_all_technologies() {
    local all=()
    all+=("${DETECTED_BACKENDS[@]}")
    all+=("${DETECTED_FRONTENDS[@]}")
    all+=("${DETECTED_DATABASES[@]}")
    all+=("${DETECTED_DEVOPS[@]}")

    # Return "universal" as fallback if no technologies detected
    if [ ${#all[@]} -eq 0 ]; then
        echo "universal"
    else
        echo "${all[@]}"
    fi
}

# Export functions
export -f detect_spring_boot detect_nodejs detect_python detect_go detect_rust detect_ruby
export -f detect_react detect_vue detect_angular detect_svelte detect_nextjs
export -f detect_postgres detect_mysql detect_mongodb detect_redis
export -f detect_docker detect_kubernetes detect_terraform
export -f detect_technologies display_detected confirm_technologies get_all_technologies
