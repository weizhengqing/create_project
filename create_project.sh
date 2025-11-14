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
        "4_analysis/processed_data"
        "4_analysis/visualizations/plots"
        "4_analysis/visualizations/figures"
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
    
    print_info "创建示例脚本文件..."
    
    # ABINIT输入配置脚本
    cat > "${base_dir}/3_scripts/abinit_input_config.py" << 'EOF'
import warnings
warnings.filterwarnings("ignore")  # to get rid of deprecation warnings

import os
import glob
import argparse
from pathlib import Path
from abipy.abilab import AbinitInput


def get_pseudo_for_structure(structure_path, pseudo_dir):
    """
    根据结构文件自动获取对应元素的赝势文件
    
    Args:
        structure_path: VASP 结构文件路径
        pseudo_dir: 赝势文件目录
    
    Returns:
        赝势文件路径列表
    """
    from pymatgen.io.vasp import Poscar
    
    # 读取结构文件获取元素列表
    poscar = Poscar.from_file(structure_path)
    elements = [str(element) for element in poscar.structure.composition.elements]
    elements = sorted(set(elements))  # 去重并排序
    
    # 构建赝势文件路径列表
    # 假设赝势文件命名格式为 Element.psp8
    pseudo_files = []
    for element in elements:
        pseudo_file = os.path.join(pseudo_dir, f"{element}.psp8")
        if os.path.exists(pseudo_file):
            pseudo_files.append(pseudo_file)
        else:
            # 如果找不到 .psp8，尝试其他常见格式
            for ext in ['.psp', '.xml', '.upf']:
                alt_pseudo = os.path.join(pseudo_dir, f"{element}{ext}")
                if os.path.exists(alt_pseudo):
                    pseudo_files.append(alt_pseudo)
                    break
            else:
                raise FileNotFoundError(f"Pseudopotential file not found for element {element} in {pseudo_dir}")
    
    return pseudo_files


def create_mainsim_script(calc_dir):
    """
    创建 mainsim 集群的提交脚本
    
    Args:
        calc_dir: 计算目录路径
    """
    script_content = """#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --job-name=Job
#SBATCH --output=job_%j.out
#SBATCH --mail-user=zhengqing.wei@physik.tu-chemnitz.de
#SBATCH --mail-type=START,END,FAIL,TIME_LIMIT
#SBATCH --partition=cpu
###SBATCH --nodelist=simep05
###SBATCH --exclude=simep04
#SBATCH --error=error

module unload openmpi
module load abinit/9.10.3/openmpi3-mkl
mpirun abinit run.abi > log
"""
    
    script_path = os.path.join(calc_dir, "mainsim.sh")
    with open(script_path, 'w') as f:
        f.write(script_content)
    
    # 添加可执行权限
    os.chmod(script_path, 0o755)
    print(f"  Created: mainsim.sh")


def create_barnard_script(calc_dir):
    """
    创建 barnard 集群的提交脚本
    
    Args:
        calc_dir: 计算目录路径
    """
    script_content = """#!/bin/bash

#SBATCH --time=5-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --cpus-per-task=1
#SBATCH --job-name=Job
#SBATCH --output=job_%j.out
#SBATCH --mail-user=zhengqing.wei@mailbox.tu-dresden.de
#SBATCH --mail-type=START,END,FAIL,TIME_LIMIT
#SBATCH --partition=barnard
#SBATCH --account=p_structures
###SBATCH --nodelist=simep05
###SBATCH --exclude=simep04
#SBATCH --error=error

module load release/24.10
module load GCC/13.2.0
module load OpenMPI/4.1.6
module load ABINIT/10.0.9

mpirun abinit run.abi >> log
"""
    
    script_path = os.path.join(calc_dir, "barnard.sh")
    with open(script_path, 'w') as f:
        f.write(script_content)
    
    # 添加可执行权限
    os.chmod(script_path, 0o755)
    print(f"  Created: barnard.sh")


def create_abinit_input(structure_file, calc_dir, pseudo_dir):
    """
    为单个结构创建 ABINIT 输入文件
    
    Args:
        structure_file: 结构文件路径
        calc_dir: 计算目录路径
        pseudo_dir: 赝势文件目录
    """
    from pymatgen.io.vasp import Poscar
    from abipy.core.structure import Structure
    
    # 获取对应的赝势文件路径
    pseudos = get_pseudo_for_structure(structure_file, pseudo_dir)
    
    # 创建 AbinitInput 对象
    inp = AbinitInput(structure=structure_file, pseudos=pseudos)
    
    # 读取 abipy 生成的结构，获取元素类型顺序
    abipy_structure = Structure.from_file(structure_file)
    
    # 获取元素类型列表（按照 abipy 内部的顺序）
    # types_of_specie 返回的是按照 typat 顺序排列的元素
    element_types = abipy_structure.types_of_specie
    
    # 生成赝势文件名列表（顺序与 znucl 对应）
    pseudo_filenames = [f"{str(elem)}.psp8" for elem in element_types]
    
    # 设置基本参数
    inp.set_vars(
        # 基本设置
        ecut=30,          # 平面波截断能量 (Ha)
        nstep=300,        # SCF 最大步数
        toldfe=1.0e-8,    # 总能量收敛容差
        tolmxf=1.0e-5,    # 最大力收敛容差
        
        # SCF 设置
        iscf=7,           # SCF 算法 (Pulay mixing)
        npulayit=5,       # Pulay 混合历史数
        
        # k-点设置
        kptopt=1,         # k-点生成选项
        kptrlatt=[[6, 0, 0], [0, 6, 0], [0, 0, 3]],  # k-点网格
        
        # 结构优化设置
        optcell=2,        # 优化晶胞形状和体积
        ionmov=2,         # 离子移动算法 (BFGS)
        ntime=200,        # 结构优化最大步数
        dilatmx=1.15,     # 最大晶格膨胀因子
        ecutsm=0.5,       # 能量平滑参数
        
        # 占据数设置
        occopt=7,         # 占据数选项 (Gaussian smearing)
        tsmear=0.04,      # 展宽温度 (Ha)
        
        # 输出控制
        prtwf=0,          # 不输出波函数
        prtden=0,         # 不输出电荷密度
        prtdos=0,         # 不输出态密度
        
        # 能带数
        nband=44,         # 能带数量
        
        # 对称性
        nsym=1,           # 对称性操作数量
        
        # 使用环境变量指定赝势目录
        pp_dirpath="$PSEUDOS",
        
        # 明确指定赝势文件名（顺序与 znucl 一致）
        pseudos=", ".join([f'"{pf}"' for pf in pseudo_filenames]),
    )
    
    # 写入 run.abi 文件
    output_file = os.path.join(calc_dir, "run.abi")
    inp.write(filepath=output_file)
    print(f"  Created: run.abi")


def create_batch_submit_script(script_dir, calculations_dir, cluster_type):
    """
    创建批量提交脚本
    
    Args:
        script_dir: 脚本目录路径
        calculations_dir: 计算目录路径
        cluster_type: 集群类型 ('mainsim', 'barnard', 或 'both')
    """
    # 根据集群类型确定要生成的脚本
    scripts_to_create = []
    
    if cluster_type in ['mainsim', 'both']:
        scripts_to_create.append(('mainsim', 'submit_all_mainsim.sh'))
    
    if cluster_type in ['barnard', 'both']:
        scripts_to_create.append(('barnard', 'submit_all_barnard.sh'))
    
    for cluster, script_name in scripts_to_create:
        script_content = f"""#!/bin/bash

# 批量提交脚本 - {cluster.upper()} 集群
# 生成时间: {os.popen('date').read().strip()}

# 设置颜色输出
GREEN='\\033[0;32m'
RED='\\033[0;31m'
YELLOW='\\033[1;33m'
NC='\\033[0m' # No Color

echo "========================================"
echo "批量提交 ABINIT 任务到 {cluster.upper()} 集群"
echo "========================================"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${{BASH_SOURCE[0]}}" )" && pwd )"

# 获取计算目录的相对路径（相对于脚本目录）
CALC_DIR="$SCRIPT_DIR/../2_calculations"

# 计数器
TOTAL=0
SUCCESS=0
FAILED=0

# 遍历所有子目录
for dir in "$CALC_DIR"/*/; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        
        # 检查是否存在提交脚本
        if [ -f "${{dir}}{cluster}.sh" ]; then
            echo -n "提交任务: $dirname ... "
            
            # 进入目录并提交任务
            cd "$dir"
            
            # 提交任务并捕获输出
            output=$(sbatch {cluster}.sh 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                # 提取作业ID
                job_id=$(echo "$output" | grep -oP '(?<=Submitted batch job )\\d+' || echo "$output")
                echo -e "${{GREEN}}✓ 成功${{NC}} (Job ID: $job_id)"
                ((SUCCESS++))
            else
                echo -e "${{RED}}✗ 失败${{NC}} - $output"
                ((FAILED++))
            fi
            
            ((TOTAL++))
            
            # 返回脚本目录
            cd - > /dev/null
            
            # 添加短暂延迟避免过快提交
            sleep 0.5
        else
            echo -e "${{YELLOW}}⊗ 跳过${{NC}}: $dirname (未找到 {cluster}.sh)"
        fi
    fi
done

echo ""
echo "========================================"
echo "提交完成!"
echo "总计: $TOTAL 个任务"
echo -e "成功: ${{GREEN}}$SUCCESS${{NC}} 个"
if [ $FAILED -gt 0 ]; then
    echo -e "失败: ${{RED}}$FAILED${{NC}} 个"
fi
echo "========================================"
echo ""
echo "使用以下命令查看任务状态:"
echo "  squeue -u $USER"
echo ""
echo "使用以下命令取消所有任务:"
echo "  scancel -u $USER"
"""
        
        script_path = os.path.join(script_dir, script_name)
        with open(script_path, 'w') as f:
            f.write(script_content)
        
        # 添加可执行权限
        os.chmod(script_path, 0o755)
        
        print(f"  Created batch submit script: {script_name}")


def main():
    """
    主函数：遍历所有结构文件并创建计算目录和输入文件
    """
    # 设置参数解析
    parser = argparse.ArgumentParser(description='Generate ABINIT input files and job scripts')
    parser.add_argument('--cluster', type=str, choices=['mainsim', 'barnard', 'both'], 
                        default='both', help='Target cluster (mainsim, barnard, or both)')
    args = parser.parse_args()
    
    # 获取当前脚本所在目录的父目录（项目根目录）
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    # 定义路径
    structures_dir = os.path.join(project_root, "1_structures", "initial_structures")
    calculations_dir = os.path.join(project_root, "2_calculations")
    
    # 检查赝势目录
    if "PSEUDOS" not in os.environ:
        print("Error: PSEUDOS environment variable is not set!")
        print("Please set it to your pseudopotential directory path.")
        return
    
    pseudo_dir = os.environ["PSEUDOS"]
    
    # 确保计算目录存在
    os.makedirs(calculations_dir, exist_ok=True)
    
    # 查找所有 VASP 文件
    vasp_files = glob.glob(os.path.join(structures_dir, "*.vasp"))
    
    if not vasp_files:
        print(f"No .vasp files found in {structures_dir}")
        return
    
    print(f"Found {len(vasp_files)} structure file(s)")
    print(f"Target cluster(s): {args.cluster}")
    print("-" * 60)
    
    # 遍历每个结构文件
    successful_count = 0
    for vasp_file in vasp_files:
        # 获取文件名（不含扩展名）
        basename = os.path.splitext(os.path.basename(vasp_file))[0]
        
        print(f"\nProcessing: {basename}")
        
        # 创建对应的计算目录
        calc_dir = os.path.join(calculations_dir, basename)
        os.makedirs(calc_dir, exist_ok=True)
        print(f"  Directory: {calc_dir}")
        
        try:
            # 创建 ABINIT 输入文件
            create_abinit_input(vasp_file, calc_dir, pseudo_dir)
            
            # 根据参数创建相应的提交脚本
            if args.cluster in ['mainsim', 'both']:
                create_mainsim_script(calc_dir)
            
            if args.cluster in ['barnard', 'both']:
                create_barnard_script(calc_dir)
                
            print(f"  ✓ Successfully processed {basename}")
            successful_count += 1
            
        except Exception as e:
            print(f"  ✗ Error processing {basename}: {str(e)}")
    
    print("\n" + "=" * 60)
    print("All structures processed!")
    print(f"Calculation directories created in: {calculations_dir}")
    
    # 如果有成功处理的文件，创建批量提交脚本
    if successful_count > 0:
        print("\n" + "-" * 60)
        print("Creating batch submission scripts...")
        create_batch_submit_script(script_dir, calculations_dir, args.cluster)
        
        print("\n" + "=" * 60)
        print("Batch submission scripts created in: " + script_dir)
        print("\nTo submit all jobs, run:")
        
        if args.cluster in ['mainsim', 'both']:
            print(f"  bash {os.path.join(script_dir, 'submit_all_mainsim.sh')}")
        
        if args.cluster in ['barnard', 'both']:
            print(f"  bash {os.path.join(script_dir, 'submit_all_barnard.sh')}")
        
        print("=" * 60)


if __name__ == "__main__":
    main()
EOF
    
    chmod +x "${base_dir}/3_scripts/abinit_input_config.py"
    print_success "ABINIT输入配置脚本创建完成"
}

# 创建文档文件
create_documentation() {
    local base_dir="$1"
    local project_name="$2"
    
    print_info "创建项目文档..."
    
    # ABINIT输入配置脚本使用说明
    cat > "${base_dir}/5_documentation/abinit_input_config_README.md" << 'EOF'
# ABINIT Input Configuration Script 使用说明

## 功能概述

`abinit_input_config.py` 脚本可以自动化处理 ABINIT 计算的准备工作，包括：

1. 遍历 `1_structures/initial_structures` 中的所有 `.vasp` 结构文件
2. 为每个结构在 `2_calculations` 中创建独立的计算目录
3. 自动识别结构中的元素并匹配对应的赝势文件
4. 生成 ABINIT 输入文件 `run.abi`
5. 根据目标集群生成相应的作业提交脚本（mainsim.sh 或 barnard.sh）

## 前置要求

### 环境配置

1. **安装必要的 Python 包：**
   ```bash
   pip install abipy pymatgen
   ```

2. **设置赝势目录环境变量：**
   ```bash
   # 在 ~/.zshrc 或 ~/.bashrc 中添加
   export PSEUDOS="/path/to/your/pseudopotential/directory"
   
   # 使配置生效
   source ~/.zshrc
   ```

### 目录结构准备

确保你的项目目录结构如下：
```
project_root/
├── 1_structures/
│   └── initial_structures/    # 放置 .vasp 结构文件
├── 2_calculations/            # 自动生成的计算目录
└── 3_scripts/
    └── abinit_input_config.py  # 本脚本
```

## 使用方法

### 基本用法

```bash
cd /Users/zhengqingwei/Desktop/test_20251102/3_scripts
python abinit_input_config.py
```

默认情况下，脚本会同时生成 mainsim 和 barnard 两种集群的提交脚本。

### 指定目标集群

**只生成 mainsim 集群脚本：**
```bash
python abinit_input_config.py --cluster mainsim
```

**只生成 barnard 集群脚本：**
```bash
python abinit_input_config.py --cluster barnard
```

**同时生成两种集群脚本（默认）：**
```bash
python abinit_input_config.py --cluster both
```

## 输出结果

运行脚本后，每个结构文件会在 `2_calculations` 中生成一个独立目录，包含：

### 文件列表

1. **run.abi** - ABINIT 输入文件，包含所有计算参数
2. **mainsim.sh** - MainSim 集群提交脚本（如果选择）
3. **barnard.sh** - Barnard 集群提交脚本（如果选择）

### 示例目录结构

```
2_calculations/
├── al6zr2b-1/
│   ├── run.abi
│   ├── mainsim.sh
│   └── barnard.sh
├── structure2/
│   ├── run.abi
│   ├── mainsim.sh
│   └── barnard.sh
└── ...
```

## 批量提交作业

脚本会自动生成批量提交脚本，可以一次性提交所有任务：

### MainSim 集群

```bash
cd 3_scripts
bash submit_all_mainsim.sh
```

### Barnard 集群

```bash
cd 3_scripts
bash submit_all_barnard.sh
```

### 单个任务提交

如果需要单独提交某个任务：

**MainSim 集群：**
```bash
cd 2_calculations/structure_name
sbatch mainsim.sh
```

**Barnard 集群：**
```bash
cd 2_calculations/structure_name
sbatch barnard.sh
```

## 计算参数说明

脚本中的 ABINIT 参数可以根据需要修改。当前使用的主要参数：

| 参数 | 值 | 说明 |
|------|-----|------|
| ecut | 30 Ha | 平面波截断能量 |
| nstep | 300 | SCF 最大步数 |
| toldfe | 1.0e-8 | 总能量收敛容差 |
| tolmxf | 1.0e-5 | 最大力收敛容差 |
| optcell | 2 | 优化晶胞形状和体积 |
| ionmov | 2 | BFGS 离子移动算法 |
| ntime | 200 | 结构优化最大步数 |
| kptrlatt | [6,6,3] | k-点网格 |

如需修改参数，请编辑 `abinit_input_config.py` 中 `create_abinit_input()` 函数的参数部分。

## 集群配置说明

### MainSim 集群

- 节点数：1
- 任务数：24
- 分区：cpu
- ABINIT 版本：9.10.3

### Barnard 集群

- 节点数：1
- 任务数：64
- 分区：barnard
- 账户：p_structures
- ABINIT 版本：10.0.9
- 最长运行时间：5天

## 故障排除

### 问题：找不到赝势文件

**错误信息：** `Error: PSEUDOS environment variable is not set!`

**解决方法：**
```bash
export PSEUDOS="/path/to/your/pseudopotentials"
```

### 问题：找不到 .vasp 文件

**错误信息：** `No .vasp files found in ...`

**解决方法：**
- 确认结构文件已放置在 `1_structures/initial_structures/` 目录中
- 确认文件扩展名为 `.vasp`

### 问题：导入 abipy 或 pymatgen 失败

**解决方法：**
```bash
pip install --upgrade abipy pymatgen
```

### 问题：赝势自动匹配失败

**可能原因：**
- 赝势目录中缺少对应元素的赝势文件
- 赝势文件命名格式不符合 abipy 的要求

**解决方法：**
- 确保赝势文件命名格式为 `Element.psp8` 或类似格式
- 检查 `$PSEUDOS` 目录中是否包含所需元素的赝势文件

## 自定义和扩展

### 修改计算参数

在 `create_abinit_input()` 函数中修改 `AbinitInput()` 的参数。

### 修改作业脚本

在 `create_mainsim_script()` 或 `create_barnard_script()` 函数中修改脚本内容。

### 添加其他集群支持

参考现有的 `create_mainsim_script()` 函数，创建新的函数并在 `main()` 中调用。

## 联系方式

如有问题，请联系：
- MainSim: zhengqing.wei@physik.tu-chemnitz.de
- Barnard: zhengqing.wei@mailbox.tu-dresden.de

## 版本历史

- v1.0 (2025-11-02): 初始版本，支持自动生成 ABINIT 输入文件和集群提交脚本
EOF

    print_success "ABINIT输入配置文档创建完成"
    
    # 使用指南
    cat > "${base_dir}/5_documentation/usage_guide.md" << EOF
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
cp your_structure.cif 1_structures/initial_structures/
\`\`\`

### 3. 设置计算任务
在计算目录中创建任务文件夹：
\`\`\`bash
mkdir -p 2_calculations/scf_YourMaterial_001
\`\`\`

### 4. 运行计算
使用提供的脚本提交任务：
\`\`\`bash
cd 3_scripts/job_management
bash job_submit.sh scf 1 5
\`\`\`

### 5. 分析结果
运行数据提取脚本：
\`\`\`bash
cd 3_scripts/postprocessing
python data_extraction.py
\`\`\`

## 常用命令

### 文件整理
\`\`\`bash
cd 3_scripts/utilities
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
    echo "   编辑 0_metadata/project_metadata.json"
    echo ""
    echo "3. 开始添加结构文件:"
    echo "   复制结构文件到 1_structures/initial_structures/"
    echo ""
    echo "4. 查看详细说明:"
    echo "   cat 5_documentation/usage_guide.md"
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
