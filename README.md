# ABINIT Working Directory Generator

An automated script to create organized directory structures for ABINIT computational materials science projects.

## Features

- **Automated Directory Creation**: Creates a comprehensive directory structure optimized for ABINIT calculations
- **Metadata Management**: Generates project metadata files including JSON configuration, CSV databases, and parameter logs
- **Project Objectives Template**: Automatically creates a detailed project objectives and task management file in English
- **Example Scripts**: Provides template scripts for job management, data extraction, and file organization
- **Documentation**: Generates project documentation including README files and usage guides

## Usage

```bash
# Basic usage - create project in current directory
bash create_project.sh "Project_Name"

# Create project in specific directory
bash create_project.sh "Project_Name" "/path/to/directory"

# Examples
bash create_project.sh "TiO2_Study"
bash create_project.sh "Graphene_Electronic_Properties"
bash create_project.sh "Material_Study" "/home/user/research"
```

## Generated Structure

```text
Project_Name_YYYYMMDD/
├── 00_metadata/
│   ├── project_metadata.json
│   ├── project_objectives.md      # New: Project goals and task management
│   ├── calculation_registry.csv
│   ├── structure_database.csv
│   └── parameter_log.txt
├── 01_structures/
│   ├── initial_structures/
│   ├── optimized_structures/
│   └── structure_templates/
├── 02_calculations/
├── 03_scripts/
│   ├── preprocessing/
│   ├── job_management/
│   ├── postprocessing/
│   └── utilities/
├── 04_analysis/
│   ├── raw_data/
│   ├── processed_data/
│   ├── visualizations/
│   └── reports/
├── 05_documentation/
└── 06_backup/
```

## Key Features

### Project Objectives Template

The script automatically generates `00_metadata/project_objectives.md` with:

- Project background and scientific context
- Research objectives and success criteria
- Task breakdown and timeline management
- TODO lists with priority levels
- Progress tracking and issue management
- Resource and reference management

### Example Scripts

Includes template scripts for:

- Job submission and management
- Data extraction from ABINIT outputs
- File organization and validation
- Project backup and maintenance

## Requirements

- Bash shell (zsh compatible)
- Git (for version control)
- Standard Unix utilities

## Installation

```bash
git clone https://github.com/yourusername/create_project.git
cd create_project
chmod +x create_project.sh
```

## Author

ABINIT Project Structure Generator v1.1
Created for computational materials science research workflow optimization.

## License

MIT License - Feel free to modify and distribute.
