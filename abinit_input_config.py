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
