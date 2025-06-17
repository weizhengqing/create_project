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
        "00_metadata"
        "01_structures/initial_structures"
        "01_structures/optimized_structures" 
        "01_structures/structure_templates"
        "02_calculations"
        "03_scripts/preprocessing"
        "03_scripts/job_management"
        "03_scripts/postprocessing"
        "03_scripts/utilities"
        "04_analysis/raw_data"
        "04_analysis/processed_data"
        "04_analysis/visualizations/plots"
        "04_analysis/visualizations/figures"
        "04_analysis/reports"
        "05_documentation"
        "06_backup"
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
    cat > "${base_dir}/00_metadata/project_metadata.json" << EOF
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
    cat > "${base_dir}/00_metadata/calculation_registry.csv" << EOF
ID,结构名称,体系,计算类型,状态,开始时间,完成时间,备注
001,示例结构,示例体系,SCF,待开始,,,请填写实际数据
EOF

    # 3. 结构数据库 CSV 文件
    cat > "${base_dir}/00_metadata/structure_database.csv" << EOF
结构ID,化学式,空间群,晶格参数a,晶格参数b,晶格参数c,文件路径,备注
001,示例化学式,P1,1.0,1.0,1.0,01_structures/raw_structures/,请填写实际数据
EOF

    # 4. 参数日志文件
    cat > "${base_dir}/00_metadata/parameter_log.txt" << EOF
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
    cat > "${base_dir}/00_metadata/project_objectives.md" << EOF
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
    
    print_info "创建示例脚本文件..."
    
    # 1. 批量提交脚本示例
    cat > "${base_dir}/03_scripts/job_management/job_submit.sh" << 'EOF'
#!/bin/bash
# ABINIT任务批量提交脚本示例
# 使用方法: bash job_submit.sh [计算类型] [起始ID] [结束ID]

CALC_TYPE=${1:-"scf"}
START_ID=${2:-1}
END_ID=${3:-1}

echo "批量提交 ${CALC_TYPE} 计算任务 (ID: ${START_ID}-${END_ID})"

for ((i=START_ID; i<=END_ID; i++)); do
    # 假设目录格式为: job类型_编号，例如: scf_001, opt_002
    JOB_DIR="../02_calculations/${CALC_TYPE}_$(printf "%03d" $i)"
    if [ -d "$JOB_DIR" ]; then
        echo "提交任务: $JOB_DIR"
        # 在这里添加具体的任务提交命令
        # 例如: sbatch ${JOB_DIR}/submit.slurm
    else
        echo "警告: 目录不存在 - $JOB_DIR"
    fi
done
EOF

    # 2. 数据提取脚本示例
    cat > "${base_dir}/03_scripts/postprocessing/data_extraction.py" << 'EOF'
#!/usr/bin/env python3
"""
ABINIT输出数据提取脚本示例
用于从ABINIT输出文件中提取关键数据
"""

import os
import re
import pandas as pd
from pathlib import Path

def extract_energy_from_output(output_file):
    """从ABINIT输出文件中提取能量数据"""
    energies = []
    
    try:
        with open(output_file, 'r') as f:
            content = f.read()
            
        # 使用正则表达式提取总能量
        pattern = r'Total energy \(eV\) = ([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)'
        matches = re.findall(pattern, content)
        
        if matches:
            energies = [float(match) for match in matches]
            
    except Exception as e:
        print(f"读取文件出错 {output_file}: {e}")
        
    return energies

def main():
    """主函数"""
    calc_dir = Path("../../02_calculations")
    results = []
    
    print("正在扫描计算目录...")
    
    # 遍历所有计算目录
    for job_dir in calc_dir.iterdir():
        if job_dir.is_dir():
            # 从目录名称中提取计算类型 (假设格式为: 类型_编号)
            job_name = job_dir.name
            calc_type = job_name.split('_')[0] if '_' in job_name else 'unknown'
            
            output_file = job_dir / "output" / "abinit.out"
            
            if output_file.exists():
                energies = extract_energy_from_output(output_file)
                
                if energies:
                    results.append({
                        'calc_type': calc_type,
                        'job_id': job_name,
                        'final_energy': energies[-1],
                        'convergence_steps': len(energies),
                        'file_path': str(output_file)
                    })
    
    # 保存结果到CSV文件
    if results:
        df = pd.DataFrame(results)
        output_path = Path("../../04_analysis/raw_data/extracted_energies.csv")
        df.to_csv(output_path, index=False)
        print(f"数据提取完成，结果保存至: {output_path}")
        print(f"共提取了 {len(results)} 个计算结果")
    else:
        print("未找到有效的计算结果")

if __name__ == "__main__":
    main()
EOF

    # 3. 文件整理工具
    cat > "${base_dir}/03_scripts/utilities/file_organizer.py" << 'EOF'
#!/usr/bin/env python3
"""
文件整理工具
用于检查和整理项目文件结构
"""

import os
import shutil
from pathlib import Path
from datetime import datetime

def check_directory_structure():
    """检查目录结构完整性"""
    required_dirs = [
        "00_metadata",
        "01_structures/raw_structures",
        "01_structures/optimized_structures",
        "01_structures/structure_templates",
        "02_calculations",
        "03_scripts",
        "04_analysis",
        "05_documentation",
        "06_backup"
    ]
    
    missing_dirs = []
    project_root = Path("../..")
    
    for dir_path in required_dirs:
        full_path = project_root / dir_path
        if not full_path.exists():
            missing_dirs.append(dir_path)
    
    if missing_dirs:
        print("缺失的目录:")
        for dir_path in missing_dirs:
            print(f"  - {dir_path}")
        return False
    else:
        print("目录结构检查通过")
        return True

def organize_files():
    """整理文件到正确的目录"""
    print("文件整理功能待实现...")
    # 在这里添加文件整理逻辑

def backup_project():
    """创建项目备份"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_name = f"backup_{timestamp}"
    
    print(f"创建备份: {backup_name}")
    # 在这里添加备份逻辑

if __name__ == "__main__":
    print("=== 项目文件整理工具 ===")
    check_directory_structure()
EOF

    # 设置脚本执行权限
    chmod +x "${base_dir}/03_scripts/job_management/job_submit.sh"
    chmod +x "${base_dir}/03_scripts/postprocessing/data_extraction.py"
    chmod +x "${base_dir}/03_scripts/utilities/file_organizer.py"
    
    print_success "示例脚本创建完成"
}

# 创建文档文件
create_documentation() {
    local base_dir="$1"
    local project_name="$2"
    
    print_info "创建项目文档..."
    
    # 1. 主README文件
    cat > "${base_dir}/README.md" << EOF
# ${project_name}

使用ABINIT进行材料计算的研究项目

## 项目结构

\`\`\`
${project_name}/
├── 00_metadata/          # 项目元数据和管理文件
├── 01_structures/        # 结构文件存储
├── 02_calculations/      # 计算任务目录
├── 03_scripts/          # 处理脚本集合
├── 04_analysis/         # 数据分析结果
├── 05_documentation/    # 项目文档
├── 06_backup/          # 备份文件
└── README.md           # 项目说明文件
\`\`\`

## 目录说明

### 00_metadata/
存放项目的核心管理文件：
- \`project_metadata.json\`: 项目基本信息
- \`calculation_registry.csv\`: 计算任务注册表
- \`structure_database.csv\`: 结构文件数据库
- \`parameter_log.txt\`: 参数变更记录

### 01_structures/
结构文件按类型分类存储：
- \`raw_structures/\`: 原始结构文件
- \`optimized_structures/\`: 优化后的结构文件
- \`structure_templates/\`: 结构模板文件

### 02_calculations/
计算任务目录，可根据需要创建自己的子目录结构

### 03_scripts/
功能脚本分类存储：
- \`preprocessing/\`: 预处理脚本
- \`job_management/\`: 任务管理脚本
- \`postprocessing/\`: 后处理脚本
- \`utilities/\`: 工具脚本

### 04_analysis/
数据分析结果：
- \`raw_data/\`: 原始数据
- \`processed_data/\`: 处理后的数据
- \`visualizations/\`: 可视化结果
- \`reports/\`: 分析报告

## 命名规范

### 结构文件命名
格式：\`{MaterialSystem}_{Structure}_{ID:03d}_{Version}.{ext}\`
示例：\`TiO2_anatase_001_v1.cif\`

### 计算任务命名
格式：\`{System}_{CalcType}_{Parameters}_{YYYYMMDD}\`
示例：\`TiO2_scf_k881_20250612\`

### 脚本文件命名
格式：\`{Function}_{Target}_{Version}.{ext}\`
示例：\`extract_energy_abinit_v2.py\`

## 使用指南

1. **添加新结构**：将结构文件放入 \`01_structures/raw_structures/\`
2. **设置计算**：在 \`02_calculations/\` 相应子目录创建计算任务
3. **运行脚本**：使用 \`03_scripts/\` 中的脚本进行批量操作
4. **分析数据**：将分析结果保存到 \`04_analysis/\`
5. **更新记录**：及时更新 \`00_metadata/\` 中的管理文件

## 备份建议

- 定期备份重要数据到 \`06_backup/\`
- 使用云存储服务同步关键文件
- 保持多个备份副本

## 联系信息

- 项目负责人：请填写
- 创建日期：$(date +%Y-%m-%d)
- ABINIT版本：请填写
EOF

    # 2. 使用指南
    cat > "${base_dir}/05_documentation/usage_guide.md" << EOF
# ${project_name} 使用指南

## 快速开始

### 1. 环境准备
确保已安装以下软件：
- ABINIT
- Python 3.x
- 必要的Python包：pandas, numpy, matplotlib

### 2. 添加结构文件
将结构文件复制到相应目录：
\`\`\`bash
cp your_structure.cif 01_structures/raw_structures/
\`\`\`

### 3. 设置计算任务
在计算目录中创建任务文件夹：
\`\`\`bash
mkdir -p 02_calculations/scf_YourMaterial_001
\`\`\`

### 4. 运行计算
使用提供的脚本提交任务：
\`\`\`bash
cd 03_scripts/job_management
bash job_submit.sh scf 1 5
\`\`\`

### 5. 分析结果
运行数据提取脚本：
\`\`\`bash
cd 03_scripts/postprocessing
python data_extraction.py
\`\`\`

## 常用命令

### 文件整理
\`\`\`bash
cd 03_scripts/utilities
python file_organizer.py
\`\`\`

### 数据备份
定期执行备份操作，保护重要数据。

## 故障排除

### 常见问题
1. **权限错误**：确保脚本文件有执行权限
2. **路径错误**：检查相对路径是否正确
3. **依赖缺失**：安装必要的软件包

### 获取帮助
查看具体脚本的帮助信息或联系项目维护人员。
EOF

    print_success "项目文档创建完成"
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
    echo "   编辑 00_metadata/project_metadata.json"
    echo ""
    echo "3. 开始添加结构文件:"
    echo "   复制结构文件到 01_structures/raw_structures/"
    echo ""
    echo "4. 查看详细说明:"
    echo "   cat README.md"
    echo ""
    echo "文件结构预览:"
    echo "$(tree "$base_dir" -L 2 2>/dev/null || find "$base_dir" -type d | head -20 | sed 's/^/  /')"
    echo ""
    print_warning "请记得填写 00_metadata/ 目录中的项目信息！"
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
