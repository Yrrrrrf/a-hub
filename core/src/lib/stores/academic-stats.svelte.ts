// src/lib/stores/academic-stats.ts
export interface AcademicStat {
    id: string;
    value: string;
    label: string;
    icon?: string;
}

class AcademicStatsStore {
    stats = $state<AcademicStat[]>([
        { 
            id: 'programs',
            value: '25+', 
            label: 'Academic Programs',
        },
        { 
            id: 'students',
            value: '1000+', 
            label: 'Active Students',
        },
        { 
            id: 'faculty',
            value: '100+', 
            label: 'Faculty Members',
        },
        { 
            id: 'success',
            value: '98%', 
            label: 'Success Rate',
        }
    ]);

    // Computed statistics
    totalStudents = $derived(
        parseInt(this.stats.find(s => s.id === 'students')?.value || '0')
    );

    getStats = () => this.stats;
    
    updateStat = (id: string, newValue: string) => {
        const statIndex = this.stats.findIndex(s => s.id === id);
        if (statIndex !== -1) {
            this.stats[statIndex] = { ...this.stats[statIndex], value: newValue };
        }
    };
}

export const academicStatsStore = new AcademicStatsStore();