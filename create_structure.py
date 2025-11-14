"""创建Al(111)表面吸附不同位点氧原子的结构文件并用VESTA可视化"""

import os
import subprocess

from ase import Atoms
from ase.build import add_adsorbate, fcc111
from ase.io import write


# =============================================================================
# 1. 创建金属结构
# =============================================================================

al_111 = fcc111('Al', size=(2, 2, 7), vacuum=15.0)

# 查看结构信息（可选）
# print(f"原子数: {len(al_111)}")
# print(f"晶胞参数: {al_111.get_cell()}")
# print(f"化学式: {al_111.get_chemical_formula()}")


# =============================================================================
# 2. 创建吸附物结构
# =============================================================================

oxygen = Atoms('O')


# =============================================================================
# 3. 结构操作
# =============================================================================

# 复制基底结构用于不同的吸附位点
al_111_top = al_111.copy()
al_111_bridge = al_111.copy()
al_111_fcc = al_111.copy()
al_111_hcp = al_111.copy()

add_adsorbate(al_111_top, 'O', height=2.0, position='ontop')
add_adsorbate(al_111_bridge, 'O', height=2.0, position='bridge')
add_adsorbate(al_111_fcc, 'O', height=2.0, position='fcc')
add_adsorbate(al_111_hcp, 'O', height=2.0, position='hcp')


# =============================================================================
# 4. 保存结构文件
# =============================================================================

write('al_111_O_top.cif', al_111_top)
write('al_111_O_bridge.cif', al_111_bridge)
write('al_111_O_fcc.cif', al_111_fcc)
write('al_111_O_hcp.cif', al_111_hcp)


# =============================================================================
# 5. 可视化
# =============================================================================

# CIF文件列表
cif_files = [
    'al_111_O_top.cif',
    'al_111_O_bridge.cif',
    'al_111_O_fcc.cif',
    'al_111_O_hcp.cif',
]

# 使用VESTA打开所有文件
for cif_file in cif_files:
    if os.path.exists(cif_file):
        try:
            # macOS上使用open命令打开VESTA
            subprocess.Popen(['open', '-a', 'VESTA', cif_file])
            print(f"已在VESTA中打开: {cif_file}")
        except Exception as e:
            print(f"打开 {cif_file} 失败: {e}")
    else:
        print(f"文件不存在: {cif_file}")