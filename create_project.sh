#!/bin/zsh

# ABINIT项目目录结构自动生成脚本
# 使用方法: bash create_abinit_project.sh [项目名称] [目标路径]
# 作者: 研究数据管理助手
# 版本: 1.1
# 日期: 2025-06-12

set -e  # 遇到错误立即退出

# 颜色定义，用于美化输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的信息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示使用说明
show_usage() {
    local script_name=$(basename "$0")
    echo "ABINIT项目目录结构生成器"
    echo ""
    echo "使用方法:"
    echo "  bash ${script_name} <项目名称> [目标路径]"
    echo ""
    echo "示例:"
    echo "  bash ${script_name} TiO2_Study                     # 在当前目录创建"
    echo "  bash ${script_name} TiO2_Study /path/to/directory  # 在指定路径创建"
    echo "  bash ${script_name} \"Graphene_Electronic_Properties\""
    echo ""
    echo "说明:"
    echo "  - 项目名称不能包含特殊字符（/、\\、:、*、?、\"、<、>、|）"
    echo "  - 如果项目名称包含空格，请用引号括起来"
    echo "  - 如果不指定目标路径，脚本将在当前目录下创建项目文件夹"
    echo "  - 如果指定目标路径，该路径必须已存在"
}

# 验证项目名称
validate_project_name() {
    local project_name="$1"
    
    if [[ -z "$project_name" ]]; then
        print_error "项目名称不能为空"
        return 1
    fi
    
    # 检查特殊字符
    if echo "$project_name" | grep -q '[/\\:*?"<>|]'; then
        print_error "项目名称不能包含以下特殊字符: / \\ : * ? \" < > |"
        return 1
    fi
    
    return 0
}

# 创建目录结构
create_directory_structure() {
    local base_dir="$1"
    
    print_info "创建目录结构..."
    
    # 主目录列表
    local directories=(
        "0_metadata"
        "1_structures/initial_structures"
        "1_structures/optimized_structures" 
        "1_structures/structure_templates"
        "2_calculations"
        "3_scripts"
        "4_analysis/raw_data"
        "4_analysis/reports"
        "5_documentation"
        "6_backup"
    )
    
    # 创建所有目录
    for dir in "${directories[@]}"; do
        mkdir -p "${base_dir}/${dir}"
        print_success "创建目录: ${dir}"
    done
}

# 生成项目元数据文件
create_metadata_files() {
    local base_dir="$1"
    local project_name="$2"
    local current_date=$(date +%Y-%m-%d)
    local current_datetime=$(date +"%Y-%m-%d %H:%M:%S")
    
    print_info "生成元数据文件..."
    
    # 1. 项目元数据 JSON 文件
    cat > "${base_dir}/0_metadata/project_metadata.json" << EOF
{
  "project_info": {
    "name": "${project_name}",
    "description": "使用ABINIT进行的材料计算研究项目",
    "principal_investigator": "请填写研究负责人",
    "start_date": "${current_date}",
    "created_datetime": "${current_datetime}",
    "abinit_version": "请填写ABINIT版本",
    "computing_environment": "请填写计算环境信息"
  },
  "calculation_parameters": {
    "ecut": "请填写截断能",
    "kpoint_sampling": "请填写k点采样",
    "exchange_correlation": "请填写交换相关泛函",
    "pseudopotentials": "请填写赝势类型"
  },
  "file_organization": {
    "naming_convention": "详见README.md",
    "backup_frequency": "daily",
    "directory_structure_version": "1.0"
  }
}
EOF

    # 2. 计算注册表 CSV 文件
    cat > "${base_dir}/0_metadata/calculation_registry.csv" << EOF
ID,结构名称,体系,计算类型,状态,开始时间,完成时间,备注
001,示例结构,示例体系,SCF,待开始,,,请填写实际数据
EOF

    # 3. 结构数据库 CSV 文件
    cat > "${base_dir}/0_metadata/structure_database.csv" << EOF
结构ID,化学式,空间群,晶格参数a,晶格参数b,晶格参数c,文件路径,备注
001,示例化学式,P1,1.0,1.0,1.0,1_structures/initial_structures/,请填写实际数据
EOF

    # 4. 参数日志文件
    cat > "${base_dir}/0_metadata/parameter_log.txt" << EOF
# ABINIT计算参数变更日志
# 项目: ${project_name}
# 创建日期: ${current_date}

=== 参数变更记录 ===
日期: ${current_date}
变更内容: 项目初始化
变更人: 请填写
详细说明: 创建项目目录结构和初始配置文件

EOF

    # 5. 项目目标和任务管理文件
    cat > "${base_dir}/0_metadata/project_objectives.md" << EOF
# Project Objectives and Task Management

## Project Information
- **Project Name**: ${project_name}
- **Created Date**: ${current_date}
- **Principal Investigator**: [Please fill in]
- **Duration**: [Please specify timeline]

## Project Background
### Scientific Context
[Describe the scientific background and motivation for this research]

### Literature Review
[Key references and previous work related to this project]

### Knowledge Gaps
[What questions remain unanswered in the field?]

## Project Objectives
### Primary Objectives
1. [Main research goal 1]
2. [Main research goal 2]
3. [Main research goal 3]

### Secondary Objectives
1. [Secondary goal 1]
2. [Secondary goal 2]

### Success Criteria
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

## Research Questions
### Primary Research Questions
1. [Key question 1]
2. [Key question 2]
3. [Key question 3]

### Hypotheses
1. [Hypothesis 1]
2. [Hypothesis 2]

## Methodology
### Computational Approach
- **DFT Code**: ABINIT
- **Exchange-Correlation Functional**: [To be determined]
- **Pseudopotentials**: [To be specified]
- **Convergence Tests**: [Energy cutoff, k-points, etc.]

### Materials/Systems
- [Material/system 1]: [Brief description]
- [Material/system 2]: [Brief description]

### Calculation Types
- [ ] Structure optimization
- [ ] Electronic band structure
- [ ] Density of states
- [ ] Phonon calculations
- [ ] Other: [Specify]

## Task Breakdown
### Phase 1: Preparation and Setup
- [ ] Literature review completion
- [ ] Software setup and testing
- [ ] Input structure preparation
- [ ] Convergence testing
- **Timeline**: [Specify dates]

### Phase 2: Bulk Calculations
- [ ] Ground state calculations
- [ ] Electronic structure analysis
- [ ] Property calculations
- **Timeline**: [Specify dates]

### Phase 3: Advanced Calculations
- [ ] [Specific advanced calculations]
- [ ] [Additional properties]
- **Timeline**: [Specify dates]

### Phase 4: Analysis and Documentation
- [ ] Data analysis and visualization
- [ ] Results interpretation
- [ ] Report/manuscript preparation
- [ ] Presentation preparation
- **Timeline**: [Specify dates]

## TODO List
### High Priority
- [ ] [High priority task 1]
- [ ] [High priority task 2]
- [ ] [High priority task 3]

### Medium Priority
- [ ] [Medium priority task 1]
- [ ] [Medium priority task 2]

### Low Priority
- [ ] [Low priority task 1]
- [ ] [Low priority task 2]

## Progress Tracking
### Completed Tasks
- [Date]: [Task description]

### Current Status
- **Current Phase**: [Phase name]
- **Progress**: [Percentage or description]
- **Next Steps**: [What to do next]

### Issues and Challenges
- [Date]: [Issue description and resolution]

## Resources and References
### Computational Resources
- **Cluster/System**: [Name and specifications]
- **Allocated Time**: [Core hours or time allocation]
- **Storage**: [Data storage capacity and backup]

### Key References
1. [Reference 1]
2. [Reference 2]
3. [Reference 3]

### Useful Links
- [Documentation links]
- [Related projects]
- [Collaboration contacts]

## Notes and Updates
### [Date]
[Update or note]

### [Date]
[Update or note]

---
*Last updated: ${current_date}*
*Project created using ABINIT project template*
EOF

    print_success "元数据文件生成完成"
}

# 创建示例脚本文件
create_example_scripts() {
    local base_dir="$1"
    
    print_info "创建示例脚本目录..."
    
    # 仅创建脚本目录，不生成任何示例文件
    mkdir -p "${base_dir}/3_scripts"
    
    print_success "脚本目录创建完成"
}

# 创建文档文件
create_documentation() {
    local base_dir="$1"
    local project_name="$2"
    
    print_info "创建文档目录..."
    
    # 仅创建文档目录，不生成任何文档文件
    mkdir -p "${base_dir}/5_documentation"
    
    print_success "文档目录创建完成"
}

# 显示完成信息
show_completion_info() {
    local base_dir="$1"
    local project_name="$2"
    local target_path="$3"
    
    echo ""
    echo "=============================================="
    print_success "项目目录创建完成！"
    echo "=============================================="
    echo ""
    echo "项目位置: $(realpath "$base_dir")"
    echo "项目名称: $project_name"
    echo ""
    echo "下一步操作："
    echo "1. 进入项目目录:"
    if [ "$target_path" = "." ]; then
        echo "   cd \"$base_dir\""
    else
        echo "   cd \"$base_dir\""
    fi
    echo ""
    echo "2. 编辑项目元数据:"
    echo "   编辑 0_metadata/project_metadata.json"
    echo ""
    echo "3. 开始添加结构文件:"
    echo "   复制结构文件到 1_structures/initial_structures/"
    echo ""
    echo "文件结构预览:"
    echo "$(tree "$base_dir" -L 2 2>/dev/null || find "$base_dir" -type d | head -20 | sed 's/^/  /')"
    echo ""
    print_warning "请记得填写 0_metadata/ 目录中的项目信息！"
}

# 验证路径是否存在
validate_path() {
    local target_path="$1"
    
    # 检查路径是否存在
    if [ ! -d "$target_path" ]; then
        print_error "指定的路径 '$target_path' 不存在"
        return 1
    fi
    
    # 检查是否有写入权限
    if [ ! -w "$target_path" ]; then
        print_error "没有写入权限到路径 '$target_path'"
        return 1
    fi
    
    return 0
}

# 主函数
main() {
    # 显示脚本标题
    echo "=============================================="
    echo "    ABINIT 项目目录结构生成器 v1.1"
    echo "=============================================="
    echo ""
    
    # 检查参数
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi
    
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_usage
        exit 0
    fi
    
    # 获取项目名称
    PROJECT_NAME="$1"
    
    # 验证项目名称
    if ! validate_project_name "$PROJECT_NAME"; then
        exit 1
    fi
    
    # 检查是否提供了目标路径
    TARGET_PATH="."  # 默认为当前目录
    if [ $# -gt 1 ]; then
        TARGET_PATH="$2"
        # 验证目标路径
        if ! validate_path "$TARGET_PATH"; then
            exit 1
        fi
        print_info "将在路径 '$TARGET_PATH' 创建项目"
    else
        print_info "将在当前目录创建项目"
    fi
    
    # 添加时间戳的项目目录名
    CURRENT_DATE=$(date +%Y%m%d)
    # 处理路径，如果是当前目录"."，则不显示路径前缀
    if [ "$TARGET_PATH" = "." ]; then
        PROJECT_DIR="${PROJECT_NAME}_${CURRENT_DATE}"
    else
        PROJECT_DIR="${TARGET_PATH}/${PROJECT_NAME}_${CURRENT_DATE}"
    fi
    
    # 检查目录是否已存在
    if [ -d "$PROJECT_DIR" ]; then
        print_warning "目录 '$PROJECT_DIR' 已存在"
        read -p "是否要覆盖现有目录? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "操作取消"
            exit 0
        fi
        rm -rf "$PROJECT_DIR"
    fi
    
    print_info "开始创建项目: $PROJECT_NAME"
    print_info "项目目录: $PROJECT_DIR"
    echo ""
    
    # 创建项目根目录
    mkdir -p "$PROJECT_DIR"
    
    # 执行创建步骤
    create_directory_structure "$PROJECT_DIR"
    create_metadata_files "$PROJECT_DIR" "$PROJECT_NAME"
    create_example_scripts "$PROJECT_DIR"
    create_documentation "$PROJECT_DIR" "$PROJECT_NAME"
    
    # 显示完成信息
    show_completion_info "$PROJECT_DIR" "$PROJECT_NAME" "$TARGET_PATH"
}

# 脚本入口点
main "$@"
